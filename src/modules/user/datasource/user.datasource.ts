import {
  CreateUserRequestDto,
  UpdatePasswordRequestDto,
  UpdateProfileRequestDto,
  UpdateUserRequestDto,
  UserResponseDto,
  UserListItemDto,
  UserPermissionsResponseDto,
  UserPaginateDto,
  UpdateImageRequestDto,
} from "../dto";
import { UserRaw, UserByIdRaw, UserPermissionsByIdRaw } from "../interface/user.interface";
import { bcryptjsAdapter, List, CustomError } from "../../../shared";
import { UserMapper } from "../mapper/user.mapper";
import { prisma } from "../../../config";

export class UserDatasource {
  async create(createUser: CreateUserRequestDto): Promise<boolean> {
    const password = await bcryptjsAdapter.hash(createUser.password);
    const roles = `{${createUser.rol.join(',')}}`;

    const user = await prisma.$queryRaw`
            CALL sp_CreateUser(
            p_user_name := ${createUser.name}::VARCHAR,
            p_user_email := ${createUser.email}::VARCHAR,
            p_user_password := ${password}::VARCHAR,
            p_roles_ids := ${roles}::INTEGER[]
    );`;
    
    return !!user;
  }

  async get(paginate: UserPaginateDto): Promise<List<UserListItemDto>> {
    const [count, users] = await Promise.all([
      prisma.$queryRaw<{ fc_countlistusers: number }[]>`
          SELECT * FROM fc_CountListUsers(
          p_search := ${paginate.search}::TEXT
      );`,

      prisma.$queryRaw<UserRaw[]>`SELECT * FROM fc_ListUsers(
          p_page := ${paginate.page}::INTEGER,
          p_limit := ${paginate.lim}::INTEGER,
          p_search := ${paginate.search}::TEXT
      );`
    ]);

    return { 
      total: count[0].fc_countlistusers, 
      items: UserMapper.toListItemDtoList(users)
    };
  }

  async getId(id: number): Promise<UserResponseDto> {
    const [ user ] = await prisma.$queryRaw<UserByIdRaw[]>`
        SELECT * FROM fc_UserById(
        p_user_id := ${id}::integer
    );`;

    if (!user) throw CustomError.notFound('User not found');

    return UserMapper.toResponseDto(user);
  }

  async getPermissions(id: number): Promise<UserPermissionsResponseDto> {
    const [ user ] = await prisma.$queryRaw<UserPermissionsByIdRaw[]>`
        SELECT * FROM fc_UserPermissionsById(
        p_user_id := ${id}::integer
    );`;

    if (!user) throw CustomError.notFound('User not found');

    return UserMapper.toPermissionsDto(user);
  }

  async update(updateUser: UpdateUserRequestDto): Promise<boolean> {
    await this.getId(updateUser.id);

    const update = { ...updateUser };

    if (update.password) {
      const password = await bcryptjsAdapter.hash(update.password);
      update.password = password;
    }

    const roles = update.rol ?`{${update.rol.join(',')}}` : null;

    const user = await prisma.$queryRaw`
            CALL sp_UpdateUser(
            p_user_id := ${updateUser.id}::INTEGER,
            p_user_name := ${update.name}::VARCHAR,
            p_user_email := ${update.email}::VARCHAR,
            p_user_password := ${update.password}::VARCHAR,
            p_roles_ids := ${roles}::INTEGER[]
    );`;

    return !!user;
  }
  
  async profile(updateProfile: UpdateProfileRequestDto): Promise<boolean> {
    await this.getId(updateProfile.id);
    const user = await prisma.user.update({
      where: { id: updateProfile.id, deleted_at: null },
      data: updateProfile!.values,
    });
    return !!user;
  }

  async image(updateImage: UpdateImageRequestDto): Promise<boolean> {
    await this.getId(updateImage.id);
    const user = await prisma.user.update({
      where: { id: updateImage.id, deleted_at: null },
      data: { image_url: updateImage.image},
    });
    return !!user;
  }

  async password(updatePassword: UpdatePasswordRequestDto): Promise<boolean> {
    const exists = await prisma.user.findFirst({
      where: { id: updatePassword.id, deleted_at: null },
    });
    if (!exists) throw CustomError.badRequest("This user does not exist");

    const valid = await bcryptjsAdapter.compare(
      updatePassword.oldPassword,
      exists.password
    );
    
    if (!valid) throw CustomError.badRequest("Incorrect password");

    const password = await bcryptjsAdapter.hash(updatePassword.password);

    const user = await prisma.user.update({
      where: { id: updatePassword.id, deleted_at: null },
      data: { password },
    });
    return !!user;
  }
  
  async delete(id: number): Promise<boolean> {
    await this.getId(id);
    const user = await prisma.user.update({
      where: { id, deleted_at: null },
      data: { deleted_at: new Date() },
    });
    return !!user;
  }
}

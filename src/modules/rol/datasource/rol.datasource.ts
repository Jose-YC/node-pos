
import { CreateRoleRequestDto, RoleListItemDto, UpdateRoleRequestDto, RolePaginateDto, RoleResponseDto } from '../dto';
import { RoleRaw, RoleByIdRaw } from "../interface/rol.interface";
import { List, CustomError } from '../../../shared';
import { RoleMapper } from '../mapper/rol.mapper';  
import { prisma } from '../../../config';

export class RoleDatasource {

    async create(createRol: CreateRoleRequestDto): Promise<boolean> {
        const permissions = `{${createRol.permissions_id.join(',')}}`;

        const rol = await prisma.$queryRaw`
            CALL sp_CreateRol(
            role_name := ${createRol.name}::text,
            role_description := ${createRol.description}::text,
            permissions_ids := ${permissions}::integer[]
        );`;

        return !!rol;
    }

    async get(paginate:RolePaginateDto): Promise<List<RoleListItemDto>> {

        const [count, roles] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistroles: number }[]>`
                SELECT * FROM fc_CountListRoles(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<RoleRaw[]>`SELECT * FROM fc_ListRoles(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistroles, 
            items: RoleMapper.toListItemDtoArray(roles)
        };
    }

    async getId(id: number): Promise<RoleResponseDto> {
        const [ rol ] = await prisma.$queryRaw<RoleByIdRaw[]>`
            SELECT * FROM fc_RolById(
            p_rol_id := ${id}::integer
        );`;

        if (!rol) throw CustomError.notFound('Rol not found');

        return RoleMapper.toResponseDto(rol);
    }

    async update(updateRol: UpdateRoleRequestDto): Promise<boolean> {
        const permissions = updateRol.permissions_id ? `{${updateRol.permissions_id.join(',')}}` : null;

        const rol = await prisma.$queryRaw`
            CALL sp_UpdateRol(
            p_role_id := ${updateRol.id}::integer,
            p_role_name := ${updateRol.name}::text,
            p_role_description := ${updateRol.description}::text,
            p_permissions_ids := ${permissions}::integer[]
        );`;

        return !!rol;
    }
    
    async delete(id: number): Promise<boolean> {
        await this.getId(id);
        const rol = await prisma.role.update({where: { id, deleted_at: null }, data: {deleted_at: new Date()}});
        return !!rol;
    }
}
import { prisma } from '../../../config';
import { List, CustomError } from '../../../shared';
import { CreatePermissionRequestDto, PermissionResponseDto, UpdatePermissionRequestDto } from '../dto';
import { PermissionPaginateDto } from '../dto/response/permission.paginate';
import { PermissionRaw } from '../interface/permission.interface';
import { PermissionMapper } from '../mapper/permission.mapper';

export class PermissionDatasource {

    async create(createPermission: CreatePermissionRequestDto): Promise<boolean> {
        const existingPermission = await prisma.permission.findFirst({where: { name: createPermission.name }});
        if (existingPermission) throw CustomError.badRequest('A permission with this name already exists');

        const permission = await prisma.permission.create({data: createPermission!});
        return !!permission;
    }
    
    async get(paginate:PermissionPaginateDto): Promise<List<PermissionResponseDto>> {
        const [count, permissions] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistpermissions: number }[]>`
                SELECT * FROM fc_CountListPermissions(
                search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<PermissionRaw[]>`SELECT * FROM fc_ListPermissions(
                page := ${paginate.page}::integer,
                lim := ${paginate.lim}::integer,
                search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistpermissions, 
            items: PermissionMapper.toResponseDtoList(permissions)
        };
    }

    async getId(id: number): Promise<PermissionResponseDto> {
        const permission: PermissionRaw | null = await prisma.permission.findFirst({
            select: {
                id: true,
                name: true,
                module: true
            },
            where: {
                id, 
                deleted_at:null 
            }
        });
        if (!permission) throw CustomError.notFound('This permission does not exist');

        return PermissionMapper.toResponseDto(permission);
    }
    
    async update(updatePermission: UpdatePermissionRequestDto): Promise<boolean> {
        await this.getId(updatePermission.id);

        if (updatePermission.name) {
            const existingPermission = await prisma.permission.findFirst({where: { name: updatePermission.name, id: { not: updatePermission.id } }});
            if (existingPermission) throw CustomError.badRequest('A permission with this name already exists');
        }

        const update = await prisma.permission.update({where: {id: updatePermission.id, deleted_at:null}, data: updatePermission!.values});
        return !!update;
    }
    
    async delete(id: number): Promise<boolean> {
        await this.getId(id);
        const permission = await prisma.permission.update({where: { id, deleted_at:null }, data: {deleted_at: new Date()}});
        return !!permission;
    }
}
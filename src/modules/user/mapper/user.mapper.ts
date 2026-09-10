import { UserByIdRaw, UserPermissionsByIdRaw, UserRaw } from "../interface/user.interface";
import { UserListItemDto, UserPermissionsResponseDto, UserResponseDto } from "../dto";

export class UserMapper {

    static toListItemDto(user: UserRaw): UserListItemDto {
        return {
            id: user.id,
            email: user.email.trim().toLowerCase(),
            name: user.name.trim().toLowerCase(),
            img: user.image_url || undefined,
        }
    }

    static toListItemDtoList(users: UserRaw[]): UserListItemDto[] {
        return users.map((user) => this.toListItemDto(user));
    }

    static toResponseDto(user: UserByIdRaw): UserResponseDto {
        const roles = Array.isArray(user.roles)
        ? user.roles.map((role) => ({
                id: role.id,
                name: role.name.trim(),
            }))
        : [];

        return {
            id: user.id,
            email: user.email.trim(),
            name: user.name.trim(),
            rol: roles,
            img: user.image_url || undefined,
        };
    }

    static toPermissionsDto(user: UserPermissionsByIdRaw): UserPermissionsResponseDto {
        return {
            id: user.id,
            email: user.email.trim(),
            name: user.name.trim(),
            permissions: Array.isArray(user.permissions)
                ? user.permissions.filter((p) => typeof p === 'string')
                : [],
        };
    }
}
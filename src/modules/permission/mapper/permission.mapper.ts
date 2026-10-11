import { PermissionOptionsRaw, PermissionRaw } from "../interface/permission.interface";
import { PermissionResponseDto } from "../dto";
import { OptionsDto } from "../../../shared";

export class PermissionMapper {
    static toResponseDto(permission: PermissionRaw): PermissionResponseDto {
      return {
        id: permission.id,
        name: permission.name,
        module: permission.module,
        description: permission.description || undefined,  
      };
    }

    static toResponseOptionsDto(permissions: PermissionOptionsRaw[]): OptionsDto[] {
        return permissions.map(permission => ({
            id: permission.id,
            label: permission.name,
        }));
    }

    static toResponseDtoList(permissions: PermissionRaw[]): PermissionResponseDto[] {
        return permissions.map(permission => this.toResponseDto(permission));
    }
}
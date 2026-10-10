import { PermissionRaw } from "../interface/permission.interface";
import { PermissionResponseDto } from "../dto";

export class PermissionMapper {
    static toResponseDto(permission: PermissionRaw): PermissionResponseDto {
      return {
        id: permission.id,
        name: permission.name,
        module: permission.module,
        description: permission.description || undefined,  
      };
    }

    static toResponseDtoList(permissions: PermissionRaw[]): PermissionResponseDto[] {
        return permissions.map(permission => this.toResponseDto(permission));
    }
}
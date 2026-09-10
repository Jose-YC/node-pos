import { UserPermissionsResponseDto } from "../dto";
import { UserDatasource } from "../datasource/user.datasource";


export class UserPermissionUsecase {

  async execute(id: number): Promise<UserPermissionsResponseDto> {
    return await new UserDatasource().getPermissions(id);
  }
}
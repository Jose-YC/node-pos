import { RoleDatasource } from "../datasource/rol.datasource";
import { RoleResponseDto } from "../dto";

export class ByIdRolUsecase {

    public async execute(id: number): Promise<RoleResponseDto> {
        return await new RoleDatasource().getId(id);
    }
}
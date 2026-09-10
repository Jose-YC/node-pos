import { RoleDatasource } from "../datasource/rol.datasource";
import { UpdateRoleRequestDto } from "../dto";

export class UpdateRolUsecase {

    public async execute(options: UpdateRoleRequestDto): Promise<boolean> {
        return await new RoleDatasource().update(options);
    }
}
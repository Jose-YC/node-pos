import { RoleDatasource } from "../datasource/rol.datasource";
import { CreateRoleRequestDto } from "../dto";

export class CreateRolUsecase {

    public async execute(options: CreateRoleRequestDto): Promise<boolean> {
        return await new RoleDatasource().create(options);
    }
}
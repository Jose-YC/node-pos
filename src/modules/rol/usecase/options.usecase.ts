import { OptionsDto } from "../../../shared";
import { RoleDatasource } from "../datasource/rol.datasource";
import { RoleOptionsDto } from "../dto/request/rol.option";

export class ListOptionsRoleUsecase {

    public async execute(options: RoleOptionsDto): Promise<OptionsDto[]> {
        return await new RoleDatasource().options(options);
    }
}
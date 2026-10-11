import { OptionsDto } from "../../../shared";
import { PermissionDatasource } from "../datasource/permission.datasource";
import { PermissionOptionsDto } from "../dto/request/permision.option";

export class ListOptionsPermissionUsecase {

    public async execute(options: PermissionOptionsDto): Promise<OptionsDto[]> {
        return await new PermissionDatasource().options(options);
    }
}
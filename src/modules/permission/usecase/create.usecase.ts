import { PermissionDatasource } from "../datasource/permission.datasource";
import { CreatePermissionRequestDto } from "../dto";

export class CreatePermissionUsecase {

    public async execute(options: CreatePermissionRequestDto): Promise<boolean> {
        return await new PermissionDatasource().create(options);
    }
}
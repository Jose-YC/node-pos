import { PermissionDatasource } from "../datasource/permission.datasource";
import { UpdatePermissionRequestDto } from "../dto";

export class UpdatePermissionUsecase {

    public async execute(options: UpdatePermissionRequestDto): Promise<boolean> {
        return await new PermissionDatasource().update(options);
    }
}
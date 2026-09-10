
import { PermissionDatasource } from "../datasource/permission.datasource";
import { PermissionResponseDto } from "../dto";

export class ByIdPermissionUsecase {

    public async execute(id: number): Promise<PermissionResponseDto> {
        return await new PermissionDatasource().getId(id);
    }
}
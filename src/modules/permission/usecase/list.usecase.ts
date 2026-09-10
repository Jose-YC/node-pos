import { List } from "../../../shared";
import { PermissionDatasource } from "../datasource/permission.datasource";
import { PermissionResponseDto, PermissionPaginateDto } from "../dto";

export class ListPermissionUsecase {

    public async execute(options: PermissionPaginateDto): Promise<List<PermissionResponseDto>> {
        return await new PermissionDatasource().get(options);
    }
}
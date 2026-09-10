import { List } from "../../../shared";
import { RoleDatasource } from "../datasource/rol.datasource";
import { RoleListItemDto, RolePaginateDto } from "../dto";

export class ListRolUsecase {

    public async execute(options: RolePaginateDto): Promise<List<RoleListItemDto>> {
        return await new RoleDatasource().get(options);
    }
}
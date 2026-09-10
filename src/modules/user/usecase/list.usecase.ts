import { List } from "../../../shared";
import { UserDatasource } from "../datasource/user.datasource";
import { UserListItemDto, UserPaginateDto } from "../dto";

export class ListUserUsecase {

    public async execute(options: UserPaginateDto): Promise<List<UserListItemDto>> {
        return await new UserDatasource().get(options);
    }
}
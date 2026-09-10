import { List } from "../../../shared";
import { BoxOpenDatasource } from "../datasource/box-open.datasource";
import { BoxOpenListItemDto, BoxOpenPaginateDto } from "../dto";

export class ListBoxOpenUsecase {

    public async execute(options: BoxOpenPaginateDto): Promise<List<BoxOpenListItemDto>> {
        return await new BoxOpenDatasource().get(options);
    }
}
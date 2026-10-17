import { OptionsDto } from "../../../shared";
import { CategoryDatasource } from "../datasource/category.datasource";
import { CategoryOptionsDto } from "../dto/request/category.option";

export class ListOptionsCategoryUsecase {

    public async execute(options: CategoryOptionsDto): Promise<OptionsDto[]> {
        return await new CategoryDatasource().options(options);
    }
}
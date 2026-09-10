import { List } from "../../../shared";
import { CategoryDatasource } from "../datasource/category.datasource";
import { CategoryResponseDto, CategoryPaginateDto } from "../dto";

export class ListCategoryUsecase {

    public async execute(options: CategoryPaginateDto): Promise<List<CategoryResponseDto>> {
        return await new CategoryDatasource().get(options);
    }
}
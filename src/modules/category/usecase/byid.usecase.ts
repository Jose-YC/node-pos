import { CategoryDatasource } from "../datasource/category.datasource";
import { CategoryResponseDto } from "../dto";

export class ByIdCategoryUsecase {

    public async execute(id: number): Promise<CategoryResponseDto> {
        return await new CategoryDatasource().getId(id);
    }
}
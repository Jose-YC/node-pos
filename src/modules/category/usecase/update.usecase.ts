import { CategoryDatasource } from "../datasource/category.datasource";
import { UpdateCategoryRequestDto } from "../dto";

export class UpdateCategoryUsecase {

    public async execute(options: UpdateCategoryRequestDto): Promise<boolean> {
        return await new CategoryDatasource().update(options);
    }
}
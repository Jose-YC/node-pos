import { CategoryDatasource } from "../datasource/category.datasource";
import { CreateCategoryRequestDto } from "../dto";

export class CreateCategoryUsecase {

    public async execute(options: CreateCategoryRequestDto): Promise<boolean> {
        return await new CategoryDatasource().create(options);
    }
}
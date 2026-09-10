import { CategoryDatasource } from "../datasource/category.datasource";

export class DeleteCategoryUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new CategoryDatasource().delete(id);
    }
}
import { ProductDatasource } from "../datasource/product.datasource";

export class DeleteProductUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new ProductDatasource().delete(id);
    }
}
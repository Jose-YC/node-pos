import { ProductDatasource } from "../datasource/product.datasource";

export class StatusProductUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new ProductDatasource().status(id);
    }
}
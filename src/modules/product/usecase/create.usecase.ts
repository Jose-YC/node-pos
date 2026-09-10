import { ProductDatasource } from "../datasource/product.datasource";
import { CreateProductRequestDto } from "../dto";

export class CreateProductUsecase {

    public async execute(options: CreateProductRequestDto): Promise<boolean> {
        return await new ProductDatasource().create(options);
    }
}
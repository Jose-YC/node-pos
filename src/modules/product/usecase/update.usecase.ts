import { ProductDatasource } from "../datasource/product.datasource";
import { UpdateProductRequestDto } from "../dto";

export class UpdateProductUsecase {

    public async execute(options: UpdateProductRequestDto): Promise<boolean> {
        return await new ProductDatasource().update(options);
    }
}
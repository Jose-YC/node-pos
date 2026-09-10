import { ProductDatasource } from "../datasource/product.datasource";
import { UpdateProductImageRequestDto } from "../dto/request/product.image";

export class ImageProductUsecase {

    public async execute(update: UpdateProductImageRequestDto): Promise<boolean> {
        return await new ProductDatasource().image(update);
    }
}
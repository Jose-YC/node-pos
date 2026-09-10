import { ProductDatasource } from "../datasource/product.datasource";
import { ProductByIdResponseDto } from "../dto";

export class ByIdProductUsecase {

    public async execute(id: number): Promise<ProductByIdResponseDto> {
        return await new ProductDatasource().getId(id);
    }
}
import { List } from "../../../shared";
import { ProductDatasource } from "../datasource/product.datasource";
import { ProductResponseDto, ProductPaginateDto } from "../dto";

export class ListProductUsecase {

    public async execute(options: ProductPaginateDto): Promise<List<ProductResponseDto>> {
        return await new ProductDatasource().get(options);
    }
}
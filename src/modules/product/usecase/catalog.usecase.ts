import { List } from "../../../shared";
import { ProductDatasource } from "../datasource/product.datasource";
import { CatalogProductResponseDto, CatalogProductPaginateDto } from "../dto";

export class ListCatalogProductUsecase {

    public async execute(options: CatalogProductPaginateDto): Promise<List<CatalogProductResponseDto>> {
        return await new ProductDatasource().getCatalog(options);
    }
}
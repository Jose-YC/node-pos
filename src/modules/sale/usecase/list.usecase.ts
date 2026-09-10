import { List } from "../../../shared";
import { SaleDatasource } from "../datasource/sale.datasource";
import { SaleListItemDto, SalePaginateDto } from "../dto";

export class ListSaleUsecase {

    public async execute(options: SalePaginateDto): Promise<List<SaleListItemDto>> {
        return await new SaleDatasource().get(options);
    }
}
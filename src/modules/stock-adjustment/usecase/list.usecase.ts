import { List } from "../../../shared";
import { StockAdjustmentDatasource } from "../datasource/stock-adjustment.datasource";
import { StockAdjustmentListItemDto, StockAdjustmentPaginateDto } from "../dto";

export class ListStockAdjustmentUsecase {

    public async execute(options: StockAdjustmentPaginateDto): Promise<List<StockAdjustmentListItemDto>> {
        return await new StockAdjustmentDatasource().get(options);
    }
}
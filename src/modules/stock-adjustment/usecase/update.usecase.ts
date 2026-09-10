import { StockAdjustmentDatasource } from "../datasource/stock-adjustment.datasource";
import { UpdateStockAdjustmentRequestDto } from "../dto";

export class UpdateStockAdjustmentUsecase {

    public async execute(options: UpdateStockAdjustmentRequestDto): Promise<boolean> {
        return await new StockAdjustmentDatasource().update(options);
    }
}
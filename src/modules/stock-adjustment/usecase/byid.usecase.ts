import { StockAdjustmentDatasource } from "../datasource/stock-adjustment.datasource";
import { StockAdjustmentResponseDto } from "../dto";

export class ByIdStockAdjustmentUsecase {

    public async execute(id: number): Promise<StockAdjustmentResponseDto> {
        return await new StockAdjustmentDatasource().getId(id);
    }
}
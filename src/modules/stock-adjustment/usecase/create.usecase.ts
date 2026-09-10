import { StockAdjustmentDatasource } from "../datasource/stock-adjustment.datasource";
import { CreateStockAdjustmentRequestDto } from "../dto";

export class CreateStockAdjustmentUsecase {

    public async execute(options: CreateStockAdjustmentRequestDto): Promise<boolean> {
        return await new StockAdjustmentDatasource().create(options);
    }
}
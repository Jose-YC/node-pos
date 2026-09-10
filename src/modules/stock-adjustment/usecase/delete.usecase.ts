import { StockAdjustmentDatasource } from "../datasource/stock-adjustment.datasource";

export class DeleteStockAdjustmentUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new StockAdjustmentDatasource().delete(id);
    }
}
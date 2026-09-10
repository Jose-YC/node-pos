import { StockAdjustmentDatasource } from "../datasource/stock-adjustment.datasource";

export class SubmitStockAdjustmentUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new StockAdjustmentDatasource().submit(id);
    }
}
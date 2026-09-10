import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";

export class DraftOrderPurchaseUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new OrderPurchaseDatasource().draft(id);
    }
}
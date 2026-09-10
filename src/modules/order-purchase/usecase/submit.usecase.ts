import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";

export class SubmitOrderPurchaseUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new OrderPurchaseDatasource().submit(id);
    }
}
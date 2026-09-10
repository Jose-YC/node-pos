import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";

export class SendOrderPurchaseUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new OrderPurchaseDatasource().send(id);
    }
}
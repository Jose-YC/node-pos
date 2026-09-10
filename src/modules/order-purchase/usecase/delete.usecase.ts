import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";

export class DeleteOrderPurchaseUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new OrderPurchaseDatasource().delete(id);
    }
}
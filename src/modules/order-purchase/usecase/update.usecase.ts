import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";
import { UpdateOrderPurchaseRequestDto } from "../dto";

export class UpdateOrderPurchaseUsecase {

    public async execute(options: UpdateOrderPurchaseRequestDto): Promise<boolean> {
        return await new OrderPurchaseDatasource().update(options);
    }
}
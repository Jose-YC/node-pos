import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";
import { CreateOrderPurchaseRequestDto } from "../dto";

export class CreateOrderPurchaseUsecase {

    public async execute(options: CreateOrderPurchaseRequestDto): Promise<boolean> {
        return await new OrderPurchaseDatasource().create(options);
    }
}
import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";
import { OrderPurchaseResponseDto } from "../dto";

export class ByIdOrderPurchaseUsecase {

    public async execute(id: number): Promise<OrderPurchaseResponseDto> {
        return await new OrderPurchaseDatasource().getId(id);
    }
}
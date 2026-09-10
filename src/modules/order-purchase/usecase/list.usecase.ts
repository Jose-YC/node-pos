import { List } from "../../../shared";
import { OrderPurchaseDatasource } from "../datasource/order-purchase.datasource";
import { OrderPurchaseListItemDto, OrderPurchasePaginateDto } from "../dto";

export class ListOrderPurchaseUsecase {

    public async execute(options: OrderPurchasePaginateDto): Promise<List<OrderPurchaseListItemDto>> {
        return await new OrderPurchaseDatasource().get(options);
    }
}
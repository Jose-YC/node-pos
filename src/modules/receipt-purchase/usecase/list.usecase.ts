import { List } from "../../../shared";
import { ReceiptPurchaseDatasource } from "../datasource/receipt-purchase.datasource";
import { ReceiptPurchaseListItemDto, ReceiptPurchasePaginateDto } from "../dto";

export class ListReceiptPurchaseUsecase {

    public async execute(options: ReceiptPurchasePaginateDto): Promise<List<ReceiptPurchaseListItemDto>> {
        return await new ReceiptPurchaseDatasource().get(options);
    }
}
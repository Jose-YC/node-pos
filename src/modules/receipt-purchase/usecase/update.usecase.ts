import { ReceiptPurchaseDatasource } from "../datasource/receipt-purchase.datasource";
import { UpdateReceiptPurchaseRequestDto } from "../dto";

export class UpdateReceiptPurchaseUsecase {

    public async execute(options: UpdateReceiptPurchaseRequestDto): Promise<boolean> {
        return await new ReceiptPurchaseDatasource().update(options);
    }
}
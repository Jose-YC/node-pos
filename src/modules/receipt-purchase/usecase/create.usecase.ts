import { ReceiptPurchaseDatasource } from "../datasource/receipt-purchase.datasource";
import { CreateReceiptPurchaseRequestDto } from "../dto";

export class CreateReceiptPurchaseUsecase {

    public async execute(options: CreateReceiptPurchaseRequestDto): Promise<boolean> {
        return await new ReceiptPurchaseDatasource().create(options);
    }
}
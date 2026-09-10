import { ReceiptPurchaseDatasource } from "../datasource/receipt-purchase.datasource";
import { ReceiptPurchaseResponseDto } from "../dto";

export class ByIdReceiptPurchaseUsecase {

    public async execute(id: number): Promise<ReceiptPurchaseResponseDto> {
        return await new ReceiptPurchaseDatasource().getId(id);
    }
}
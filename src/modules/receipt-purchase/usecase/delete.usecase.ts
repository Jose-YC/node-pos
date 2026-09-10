import { ReceiptPurchaseDatasource } from "../datasource/receipt-purchase.datasource";

export class DeleteReceiptPurchaseUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new ReceiptPurchaseDatasource().delete(id);
    }
}
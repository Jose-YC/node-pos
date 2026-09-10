import { ReceiptPurchaseDatasource } from "../datasource/receipt-purchase.datasource";

export class SubmitReceiptPurchaseUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new ReceiptPurchaseDatasource().submit(id);
    }
}
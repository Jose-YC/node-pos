import { ZodAdapter } from "../../../../shared";
import { CreateReceiptPurchaseInput, CreateReceiptPurchaseSchema } from "../../schema/receipt-purchase.schema";

interface itemsReceipt {
    product_id:number
    qty_received: number
    qty_reject: number
    qty_accepted:number
}

export class CreateReceiptPurchaseRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly purchaseid:number,
        public readonly items:itemsReceipt[],
    ){}

    static create(props: {[key:string]:any}): CreateReceiptPurchaseRequestDto{

        const { userid, purchase_id, items } = ZodAdapter.validate<CreateReceiptPurchaseInput>(CreateReceiptPurchaseSchema, props);

        return new CreateReceiptPurchaseRequestDto(
            userid,
            purchase_id, 
            items.map(item => ({ ...item, qty_accepted: Number((item.qty_received - item.qty_reject))})) 
        );
    }
}
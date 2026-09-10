import { ZodAdapter } from "../../../../shared";
import { UpdateReceiptPurchaseInput, UpdateReceiptPurchaseSchema } from "../../schema/receipt-purchase.schema";

interface itemsReceipt {
    product_id:number
    qty_received: number
    qty_reject: number
    qty_accepted:number
}

export class UpdateReceiptPurchaseRequestDto {

    private constructor(
        public readonly id:number,
        public readonly items?:itemsReceipt[],
    ){}

    static create(props: {[key:string]:any}): UpdateReceiptPurchaseRequestDto{

        const { id, items } = ZodAdapter.validate<UpdateReceiptPurchaseInput>(UpdateReceiptPurchaseSchema, props);

        return new UpdateReceiptPurchaseRequestDto(
            id,
            items.map(item => ({ ...item, qty_accepted: Number((item.qty_received - item.qty_reject))})) 
        );
    }
}
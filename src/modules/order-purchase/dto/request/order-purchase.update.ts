import { ZodAdapter } from "../../../../shared";
import { UpdateOrderPurchaseInput, UpdateOrderPurchaseSchema } from "../../schema/order-purchase.schema";

interface itemsOrder {
    product_id:number
    qty: number
    price: number
    subtotal:number
}

export class UpdateOrderPurchaseRequestDto {

    private constructor(
        public readonly id:number,
        public readonly supplier_id?:number,
        public readonly address?:string,
        public readonly delivery_date?:Date,
        public readonly items?:itemsOrder[],
    ){}

    static create(props: {[key:string]:any}): UpdateOrderPurchaseRequestDto{

        const { id, supplier_id, address, delivery_date, items } = ZodAdapter.validate<UpdateOrderPurchaseInput>(UpdateOrderPurchaseSchema, props);

        return new UpdateOrderPurchaseRequestDto(
            id, 
            supplier_id, 
            address, 
            delivery_date, 
            items ? items.map(item => ({ ...item, subtotal: Number((item.qty * item.price).toFixed(2))})) : undefined
        );
    }
}
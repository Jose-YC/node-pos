import { ZodAdapter } from "../../../../shared";
import { CreateOrderPurchaseInput, CreateOrderPurchaseSchema } from "../../schema/order-purchase.schema";

interface itemsOrder {
    product_id:number
    qty: number
    price: number
    subtotal:number
}

export class CreateOrderPurchaseRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly supplier_id:number,
        public readonly address:string,
        public readonly delivery_date:Date,
        public readonly items:itemsOrder[],
    ){}

    static create(props: {[key:string]:any}): CreateOrderPurchaseRequestDto{

        const { userid, supplier_id, address, delivery_date, items } = ZodAdapter.validate<CreateOrderPurchaseInput>(CreateOrderPurchaseSchema, props);

        return new CreateOrderPurchaseRequestDto(
            userid,
            supplier_id, 
            address, 
            delivery_date, 
            items.map(item => ({ ...item, subtotal: Number((item.qty * item.price).toFixed(2))})) 
        );
    }
}
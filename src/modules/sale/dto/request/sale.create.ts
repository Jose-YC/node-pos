import { TipeDocument, ZodAdapter } from "../../../../shared";
import { CreateSaleInput, CreateSaleSchema } from "../../schema/sale.schema";

interface Customer {
    customer_id?: number,
    customer_type?: TipeDocument,
    customer_number?: string,
    customer_name?: string
}

interface Items {
    product_id: number,
    qty: number
}

interface Payment {
    payment_id: number,
    amount: number
}

export class CreateSaleRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly box_open_id:number,
        public readonly paid_amount:number,
        public readonly items:Items[],
        public readonly payment:Payment[],
        public readonly customer?:Customer,
    ){}

    static create(props: {[key:string]:any}): CreateSaleRequestDto{

        const { userid, box_open_id, customer, items, payment } = ZodAdapter.validate<CreateSaleInput>(CreateSaleSchema, props);

        const paid_amount = payment.reduce((acumulador, objeto) => acumulador + objeto.amount, 0);

        return new CreateSaleRequestDto(userid, box_open_id,  paid_amount, items, payment, customer);
    }
}
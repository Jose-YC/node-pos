import { TipeDocument, ZodAdapter } from "../../../../shared";
import { CreateCreditNoteInput, CreateCreditNoteSchema } from "../../schema/sale.schema";

interface Items {
    product_id: number,
    qty: number
}

interface Payment {
    payment_id: number,
    amount: number
}

export class CreateCreditNoteRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly saleid:number,
        public readonly box_open_id:number,
        public readonly paid_amount:number,
        public readonly items:Items[],
        public readonly payment:Payment[],
        public readonly notes?:string
    ){}

    static create(props: {[key:string]:any}): CreateCreditNoteRequestDto{

        const { saleid, userid, box_open_id, items, payment, notes } = ZodAdapter.validate<CreateCreditNoteInput>(CreateCreditNoteSchema, props);

        const paid_amount = payment.reduce((acumulador, objeto) => acumulador + objeto.amount, 0);

        return new CreateCreditNoteRequestDto(userid, saleid, box_open_id,  paid_amount, items, payment, notes);
    }
}
import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginatePaymentInput, PaginatePaymentSchema } from "../../schema/payment.schema";

export class PaymentPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): PaymentPaginateDto {
        
        const { page, lim, search } = ZodAdapter.validate<PaginatePaymentInput>(PaginatePaymentSchema, object);

        return new PaymentPaginateDto(page, lim, search?.trim().toLowerCase());
    }
}
import { ZodAdapter } from "../../../../shared";
import { OptionsPaymentInput, OptionsPaymentSchema } from "../../schema/payment.schema";

export class PaymentOptionsDto {

    private constructor(
        public readonly search?:string,
    ) {}   

    static create(object:{[key:string]:any}): PaymentOptionsDto {
        
        const { search } = ZodAdapter.validate<OptionsPaymentInput>(OptionsPaymentSchema, object);

        return new PaymentOptionsDto(search);
    }
}
import { ZodAdapter } from "../../../../shared";
import { PaymentType } from "../../interface/payment.interface";
import { CreatePaymentInput, CreatePaymentSchema } from "../../schema/payment.schema";

export class CreatePaymentRequestDto {

    private constructor(
        public readonly name:string,
        public readonly type:PaymentType,
    ){}

    static create(props: {[key:string]:any}): CreatePaymentRequestDto{
        
        const { name, type } = ZodAdapter.validate<CreatePaymentInput>(CreatePaymentSchema, props);

        return new CreatePaymentRequestDto(name, type);
    }
}
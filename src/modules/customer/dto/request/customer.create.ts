import { ZodAdapter } from "../../../../shared";
import { CreateCustomerInput, CreateCustomerSchema } from "../../schema/customer.schema";

export class CreateCustomerRequestDto {

    private constructor(
        public readonly name:string,
        public readonly doc_code:string,
        public readonly doc_number:string,
        public readonly email?:string,
        public readonly phone?:string,
    ){}

    static create(props: {[key:string]:any}): CreateCustomerRequestDto{
        
        const { name, doc_code, doc_number, email, phone } = ZodAdapter.validate<CreateCustomerInput>(CreateCustomerSchema, props);

        return new CreateCustomerRequestDto(name, doc_code, doc_number, email, phone);
    }
}
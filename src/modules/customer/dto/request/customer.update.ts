import { ZodAdapter } from "../../../../shared";
import { UpdateCustomerInput, UpdateCustomerSchema } from "../../schema/customer.schema";

export class UpdateCustomerRequestDto {

    private constructor(
        public readonly id:number,
        public readonly doc_code?:string,
        public readonly doc_number?:string,
        public readonly name?:string,
        public readonly email?:string,
        public readonly phone?:string,
    ){}

    static create(props: {[key:string]:any}): UpdateCustomerRequestDto{
        
        const { id, doc_code, doc_number, name, email, phone } = ZodAdapter.validate<UpdateCustomerInput>(UpdateCustomerSchema, {...props, id: Number(props.id) });
        
        return new UpdateCustomerRequestDto(id, doc_code, doc_number, name, email, phone);
    }
}
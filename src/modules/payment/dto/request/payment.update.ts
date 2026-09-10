import { ZodAdapter } from "../../../../shared";
import { UpdatePaymentInput, UpdatePaymentSchema } from "../../schema/payment.schema";

export class UpdatePaymentRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name:string
    ){}

    get values(){
        const returnObj: {[key:string]: any}={}
        if (this.name) returnObj.name=this.name;
        return returnObj;
    }

    static create(props: {[key:string]:any}): UpdatePaymentRequestDto{
        
        const { id, name } = ZodAdapter.validate<UpdatePaymentInput>(UpdatePaymentSchema, {...props, id: Number(props.id) });
        
        return new UpdatePaymentRequestDto(id, name);
    }
}
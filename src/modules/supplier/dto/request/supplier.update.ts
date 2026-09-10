import { ZodAdapter } from "../../../../shared";
import { SuplierType } from "../../interface/supplier.interface";
import { UpdateSupplierInput, UpdateSupplierSchema } from "../../schema/supplier.schema";

export class UpdateSupplierRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
        public readonly type?:SuplierType,
        public readonly email?:string,
        public readonly phone?:string,
    ){}

    get values(){
        const returnObj: {[key:string]: any}={}
        if (this.name) returnObj.name=this.name;
        if (this.type) returnObj.type=this.type;
        if (this.email) returnObj.email=this.email;
        if (this.phone) returnObj.phone=this.phone;
        return returnObj;
    }

    static create(props: {[key:string]:any}): UpdateSupplierRequestDto{
        
        const { id, name, type, email, phone } = ZodAdapter.validate<UpdateSupplierInput>(UpdateSupplierSchema, {...props, id: Number(props.id) });
        
        return new UpdateSupplierRequestDto(id, name, type, email, phone);
    }
}
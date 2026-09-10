import { ZodAdapter } from "../../../../shared";
import { SuplierType } from "../../interface/supplier.interface";
import { CreateSupplierInput, CreateSupplierSchema } from "../../schema/supplier.schema"

export class CreateSupplierRequestDto {

    private constructor(
        public readonly name:string,
        public readonly type:SuplierType,
        public readonly ruc:string,
        public readonly email?:string,
        public readonly phone?:string,
    ){}

    static create(props: {[key:string]:any}): CreateSupplierRequestDto{
        
        const { name, type, ruc, email, phone } = ZodAdapter.validate<CreateSupplierInput>(CreateSupplierSchema, props);

        return new CreateSupplierRequestDto(name, type, ruc, email, phone);
    }
}
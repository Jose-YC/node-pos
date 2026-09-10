import { SuplierType } from "../../interface/supplier.interface";

export class SupplierResponseDto {

    constructor(
        public readonly id:number,
        public readonly name:string,
        public readonly type:SuplierType,
        public readonly ruc:string,
        public readonly email?:string,
        public readonly phone?:string,
    ){}
}
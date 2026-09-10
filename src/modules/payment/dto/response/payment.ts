import { PaymentType } from "../../interface/payment.interface";

export class PaymentResponseDto {

    constructor(
        public id:number,
        public name:string,
        public type:PaymentType,
        public status:boolean,
    ){}
}
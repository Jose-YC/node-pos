
import { SaleDetailResponseDto } from "./sale-detail.byid";
import { SalePaymentDetailResponseDto } from "./sale-payment-detail.byid";

export class SaleResponseDto {
    constructor(
        public id: number,
        public sale_date: Date,
        public serie: string,
        public type: string,
        public customer_name: string,
        public customer_doc_code: string,
        public customer_doc_number:string,
        public igv_rate:number,
        public taxable_amount:number,
        public igv_total:number,
        public total:number,
        public paid_amount:number,
        public change_amount:number,
        public items: SaleDetailResponseDto[],
        public payments: SalePaymentDetailResponseDto[],
        public is_return:boolean,
        public return_against_id?:number,
    ){}
}
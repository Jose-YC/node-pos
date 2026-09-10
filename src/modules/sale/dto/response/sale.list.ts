
export class SaleListItemDto {

    constructor(
        public id:number,
        public serie:string,
        public doc_type:string,
        public sale_date:Date,
        public customer_name:string,
        public customer_doc_code:string,
        public customer_doc_number:string,
        public igv_rate:number,
        public taxable_amount:number,
        public igv_total:number,
        public total:number,
        public paid_amount:number,
        public change_amount:number,
        public is_return:boolean,
        public return_against_id?:number
    ){}
}
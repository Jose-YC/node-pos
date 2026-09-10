import { OrderPurchaseDetailResponseDto } from "./order-purchase-detail.byid";

export class OrderPurchaseResponseDto {
    constructor(
        public id: number,
        public serie: string,
        public status: string,
        public supplier_id: number,
        public supplier_ruc: string,
        public supplier_name:string,
        public address_purchase:string,
        public delivery_date:Date,
        public total:number,
        public items: OrderPurchaseDetailResponseDto[]
    ){}
}
import { ReceiptPurchaseDetailResponseDto } from "./receipt-purchase-detail.byid";

export class ReceiptPurchaseResponseDto {
    constructor(
        public id: number,
        public serie: string,
        public status: string,
        public supplier_id: number,
        public supplier_ruc: string,
        public supplier_name:string,
        public date_receipt:Date,
        public total:number,
        public items: ReceiptPurchaseDetailResponseDto[],
        public note?:string,
    ){}
}
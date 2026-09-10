export class ReceiptPurchaseListItemDto {
    constructor(
        public id: number,
        public serie: string,
        public status: string,
        public supplier_ruc: string,
        public supplier_name:string,
        public date_receipt:Date,
        public total:number,
        
    ){}
}
export class OrderPurchaseListItemDto {
    constructor(
        public id: number,
        public serie: string,
        public status: string,
        public supplier_ruc: string,
        public supplier_name:string,
        public delivery_date:Date,
        public total:number,
    ){}
}
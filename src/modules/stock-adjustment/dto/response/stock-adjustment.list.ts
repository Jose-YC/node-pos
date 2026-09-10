
export class StockAdjustmentListItemDto {

    constructor(
        public id:number,
        public serie:string,
        public adjustment_date:Date,
        public reason:string,
        public direction:string,
        public total_qty:number,
        public total_value:number,
        public status:string,
    ){}
}
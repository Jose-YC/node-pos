
import { StockAdjustmentDetailResponseDto } from "./stock-adjustment-detail.byid";

export class StockAdjustmentResponseDto {
    constructor(
        public id: number,
        public serie: string,
        public status:string,
        public adjustment_date: Date,
        public reason_id: number,
        public reason_name: string,
        public direction: string,
        public total_qty:number,
        public total_value:number,
        public items: StockAdjustmentDetailResponseDto[],
        public notes?:string,
    ){}
}
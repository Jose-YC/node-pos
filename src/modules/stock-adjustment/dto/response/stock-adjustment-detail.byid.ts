export class StockAdjustmentDetailResponseDto {
    constructor(
        public product_id: number,
        public product_name: string,
        public qty: number,
        public valuation_rate: number,
        public subtotal:number
    ){}
}
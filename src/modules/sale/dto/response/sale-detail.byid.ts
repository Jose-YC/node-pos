export class SaleDetailResponseDto {
    constructor(
        public product_id: number,
        public product_name: string,
        public qty: number,
        public price: number,
        public subtotal:number
    ){}
}
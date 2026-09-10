export class OrderPurchaseDetailResponseDto {
    constructor(
        public product_id: number,
        public product_name: string,
        public qty_received: number,
        public qty: number,
        public price: number,
        public subtotal:number
    ){}
}
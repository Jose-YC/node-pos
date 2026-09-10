export class ReceiptPurchaseDetailResponseDto {
    constructor(
        public product_id: number,
        public product_name: string,
        public qty_order: number,
        public qty_received: number,
        public qty_reject: number,
        public qty_accepted: number,
        public price: number,
        public subtotal:number
    ){}
}
export class SalePaymentDetailResponseDto {
    constructor(
        public payment_id: number,
        public payment_name: string,
        public amount: number
    ){}
}
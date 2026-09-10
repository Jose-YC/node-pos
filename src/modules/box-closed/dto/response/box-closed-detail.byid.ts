export class ClosedBoxDetailResponseDto {
    constructor(
        public mode_payment: number,
        public mode_payment_name: string,
        public opening_amount: number,
        public expected_amount: number,
        public closing_amount: number,
        public difference_amount: number
    ){}
}
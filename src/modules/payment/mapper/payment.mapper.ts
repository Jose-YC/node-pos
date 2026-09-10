import { PaymentResponseDto } from "../dto";
import { PaymentRaw, PaymentType } from "../interface/payment.interface";

export class PaymentMapper {
    static toResponseDto(Payment: PaymentRaw): PaymentResponseDto {
      return {
        id: Payment.id,
        name: Payment.name.trim(),
        type: Payment.type as PaymentType,
        status: Payment.status
      };
    }

    static toResponseDtoList(Payments: PaymentRaw[]): PaymentResponseDto[] {
        return Payments.map(Payment => this.toResponseDto(Payment));
    }
}
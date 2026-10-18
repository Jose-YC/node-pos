import { PaymentResponseDto } from "../dto";
import { PaymentRaw, PaymentType } from "../interface/payment.interface";

export class PaymentMapper {
    static toResponseDto(payment: PaymentRaw): PaymentResponseDto {
      return {
        id: payment.id,
        name: payment.name.trim(),
        type: payment.type as PaymentType,
        status: payment.status
      };
    }

    static toResponseDtoList(payments: PaymentRaw[]): PaymentResponseDto[] {
        return payments.map(payment => this.toResponseDto(payment));
    }
}
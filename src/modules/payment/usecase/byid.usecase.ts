import { PaymentDatasource } from "../datasource/payment.datasource";
import { PaymentResponseDto } from "../dto";

export class ByIdPaymentUsecase {

    public async execute(id: number): Promise<PaymentResponseDto> {
        return await new PaymentDatasource().getId(id);
    }
}
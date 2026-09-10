import { PaymentDatasource } from "../datasource/payment.datasource";
import { UpdatePaymentRequestDto } from "../dto";

export class UpdatePaymentUsecase {

    public async execute(options: UpdatePaymentRequestDto): Promise<boolean> {
        return await new PaymentDatasource().update(options);
    }
}
import { PaymentDatasource } from "../datasource/payment.datasource";
import { CreatePaymentRequestDto } from "../dto";

export class CreatePaymentUsecase {

    public async execute(options: CreatePaymentRequestDto): Promise<boolean> {
        return await new PaymentDatasource().create(options);
    }
}
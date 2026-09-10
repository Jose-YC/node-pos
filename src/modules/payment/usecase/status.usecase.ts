import { PaymentDatasource } from "../datasource/payment.datasource";
import { UpdatePaymentRequestDto } from "../dto";

export class StatusPaymentUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new PaymentDatasource().status(id);
    }
}
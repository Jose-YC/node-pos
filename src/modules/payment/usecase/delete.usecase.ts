import { PaymentDatasource } from "../datasource/payment.datasource";

export class DeletePaymentUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new PaymentDatasource().delete(id);
    }
}
import { OptionsDto } from "../../../shared";
import { PaymentDatasource } from "../datasource/payment.datasource";
import { PaymentOptionsDto } from "../dto/request/payment.option";

export class ListOptionsPaymentUsecase {

    public async execute(options: PaymentOptionsDto): Promise<OptionsDto[]> {
        return await new PaymentDatasource().options(options);
    }
}
import { List } from "../../../shared";
import { PaymentDatasource } from "../datasource/payment.datasource";
import { PaymentResponseDto, PaymentPaginateDto } from "../dto";

export class ListPaymentUsecase {

    public async execute(options: PaymentPaginateDto): Promise<List<PaymentResponseDto>> {
        return await new PaymentDatasource().get(options);
    }
}
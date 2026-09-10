import { CustomerDatasource } from "../datasource/customer.datasource";
import { CustomerResponseDto } from "../dto";

export class ByIdCustomerUsecase {

    public async execute(id: number): Promise<CustomerResponseDto> {
        return await new CustomerDatasource().getId(id);
    }
}
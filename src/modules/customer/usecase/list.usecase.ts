import { List } from "../../../shared";
import { CustomerDatasource } from "../datasource/customer.datasource";
import { CustomerResponseDto, CustomerPaginateDto } from "../dto";

export class ListCustomerUsecase {

    public async execute(options: CustomerPaginateDto): Promise<List<CustomerResponseDto>> {
        return await new CustomerDatasource().get(options);
    }
}
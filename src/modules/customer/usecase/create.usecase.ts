import { CustomerDatasource } from "../datasource/customer.datasource";
import { CreateCustomerRequestDto } from "../dto";

export class CreateCustomerUsecase {

    public async execute(options: CreateCustomerRequestDto): Promise<boolean> {
        return await new CustomerDatasource().create(options);
    }
}
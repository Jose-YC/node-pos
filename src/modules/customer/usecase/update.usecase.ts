import { CustomerDatasource } from "../datasource/customer.datasource";
import { UpdateCustomerRequestDto } from "../dto";

export class UpdateCustomerUsecase {

    public async execute(options: UpdateCustomerRequestDto): Promise<boolean> {
        return await new CustomerDatasource().update(options);
    }
}
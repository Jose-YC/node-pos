import { CustomerDatasource } from "../datasource/customer.datasource";

export class DeleteCustomerUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new CustomerDatasource().delete(id);
    }
}
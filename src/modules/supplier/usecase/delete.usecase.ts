import { SupplierDatasource } from "../datasource/supplier.datasource";

export class DeleteSupplierUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new SupplierDatasource().delete(id);
    }
}
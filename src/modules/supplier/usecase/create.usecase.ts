import { SupplierDatasource } from "../datasource/supplier.datasource";
import { CreateSupplierRequestDto } from "../dto";

export class CreateSupplierUsecase {

    public async execute(options: CreateSupplierRequestDto): Promise<boolean> {
        return await new SupplierDatasource().create(options);
    }
}
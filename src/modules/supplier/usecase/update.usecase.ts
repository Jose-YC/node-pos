import { SupplierDatasource } from "../datasource/supplier.datasource";
import { UpdateSupplierRequestDto } from "../dto";

export class UpdateSupplierUsecase {

    public async execute(options: UpdateSupplierRequestDto): Promise<boolean> {
        return await new SupplierDatasource().update(options);
    }
}
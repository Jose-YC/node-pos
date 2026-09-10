import { SupplierDatasource } from "../datasource/supplier.datasource";
import { SupplierResponseDto } from "../dto";

export class ByIdSupplierUsecase {

    public async execute(id: number): Promise<SupplierResponseDto> {
        return await new SupplierDatasource().getId(id);
    }
}
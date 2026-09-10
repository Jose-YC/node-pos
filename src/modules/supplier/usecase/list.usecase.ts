import { List } from "../../../shared";
import { SupplierDatasource } from "../datasource/supplier.datasource";
import { SupplierResponseDto, SupplierPaginateDto } from "../dto";

export class ListSupplierUsecase {

    public async execute(options: SupplierPaginateDto): Promise<List<SupplierResponseDto>> {
        return await new SupplierDatasource().get(options);
    }
}
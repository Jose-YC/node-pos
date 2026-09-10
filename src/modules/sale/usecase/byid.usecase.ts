import { SaleDatasource } from "../datasource/sale.datasource";
import { SaleResponseDto } from "../dto";

export class ByIdSaleUsecase {

    public async execute(id: number): Promise<SaleResponseDto> {
        return await new SaleDatasource().getId(id);
    }
}
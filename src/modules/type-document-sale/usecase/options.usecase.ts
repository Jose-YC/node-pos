import { OptionsDto } from "../../../shared";
import { TypeDocumentSaleDatasource } from "../datasource/type-document-sale.datasource";

export class ListOptionsTypeDocumentSaleUsecase {

    public async execute(): Promise<OptionsDto[]> {
        return await new TypeDocumentSaleDatasource().options();
    }
}
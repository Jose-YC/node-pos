import { TypeDocumentSaleDatasource } from "../datasource/type-document-sale.datasource";
import { TypeDocumentSaleResponseDto } from "../dto/response/type-document-sale.list";

export class ListTypeDocumentSaleUsecase {

    public async execute(): Promise<TypeDocumentSaleResponseDto[]> {
        return await new TypeDocumentSaleDatasource().getAll();
    }
}
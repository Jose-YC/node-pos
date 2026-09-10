import { TypeDocumentSaleDatasource } from "../datasource/type-document-sale.datasource";
import { TypeDocumentSaleStatusResponseDto } from "../dto";

export class ListTypeDocumentSaleStatusUsecase {

    public async execute(): Promise<TypeDocumentSaleStatusResponseDto[]> {
        return await new TypeDocumentSaleDatasource().getStatus();
    }
}
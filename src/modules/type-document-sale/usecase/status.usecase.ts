import { TypeDocumentSaleDatasource } from "../datasource/type-document-sale.datasource";

export class StatusTypeDocumentSaleUsecase {

    public async execute(id: string): Promise<boolean> {
        return await new TypeDocumentSaleDatasource().status(id);
    }
}
import { IdentityDocumentTypeDatasource } from "../datasource/identity-document-type.datasource";

export class StatusIdentityDocumentTypeUsecase {

    public async execute(id: string): Promise<boolean> {
        return await new IdentityDocumentTypeDatasource().status(id);
    }
}
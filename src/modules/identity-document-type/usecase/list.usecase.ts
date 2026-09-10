import { IdentityDocumentTypeDatasource } from "../datasource/identity-document-type.datasource";
import { IdentityDocumentTypeResponseDto } from "../dto/response/identity-document-type.list";

export class ListIdentityDocumentTypeUsecase {

    public async execute(): Promise<IdentityDocumentTypeResponseDto[]> {
        return await new IdentityDocumentTypeDatasource().get();
    }
}
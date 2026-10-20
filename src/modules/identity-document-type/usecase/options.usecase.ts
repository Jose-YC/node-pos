import { OptionsDto } from "../../../shared";
import { IdentityDocumentTypeDatasource } from "../datasource/identity-document-type.datasource";

export class ListOptionsIdentityDocumentTypeUsecase {

    public async execute(): Promise<OptionsDto[]> {
        return await new IdentityDocumentTypeDatasource().options();
    }
}
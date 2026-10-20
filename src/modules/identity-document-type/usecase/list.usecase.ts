import { List } from "../../../shared";
import { IdentityDocumentTypeDatasource } from "../datasource/identity-document-type.datasource";
import { IdentityDocumentTypePaginateDto, IdentityDocumentTypeResponseDto } from "../dto";

export class ListIdentityDocumentTypeUsecase {

    public async execute(paginate: IdentityDocumentTypePaginateDto): Promise<List<IdentityDocumentTypeResponseDto>> {
        return await new IdentityDocumentTypeDatasource().get(paginate);
    }
}
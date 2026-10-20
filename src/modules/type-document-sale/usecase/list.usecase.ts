import { List } from "../../../shared";
import { TypeDocumentSaleDatasource } from "../datasource/type-document-sale.datasource";
import { TypeDocumentSalePaginateDto, TypeDocumentSaleResponseDto } from "../dto";

export class ListTypeDocumentSaleUsecase {

    public async execute(paginate:TypeDocumentSalePaginateDto): Promise<List<TypeDocumentSaleResponseDto>> {
        return await new TypeDocumentSaleDatasource().get(paginate);
    }
}
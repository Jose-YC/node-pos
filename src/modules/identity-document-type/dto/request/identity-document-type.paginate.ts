import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateIdentityDocumentTypeInput, PaginateIdentityDocumentTypeSchema } from "../../schema/identity-document-type.schema";

export class IdentityDocumentTypePaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly limit:number,
        public readonly search?:string,
    ) {
        super(page, limit, search);
    }   

    static create(object:{[key:string]:any}): IdentityDocumentTypePaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateIdentityDocumentTypeInput>(PaginateIdentityDocumentTypeSchema, object);

        return new IdentityDocumentTypePaginateDto(page, limit, search);
    }
}
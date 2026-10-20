import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateTypeDocumentSaleInput, PaginateTypeDocumentSaleSchema } from "../../schema/type-document-sale.schema";

export class TypeDocumentSalePaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly limit:number,
        public readonly search?:string,
    ) {
        super(page, limit, search);
    }   

    static create(object:{[key:string]:any}): TypeDocumentSalePaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateTypeDocumentSaleInput>(PaginateTypeDocumentSaleSchema, object);

        return new TypeDocumentSalePaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
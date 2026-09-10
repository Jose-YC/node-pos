import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateCatalogProductInput, PaginateCatalogProductSchema } from "../../schema/product.schema";

export class CatalogProductPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
        public readonly category?:number,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): CatalogProductPaginateDto {
        
        const { page, lim, search, category } = ZodAdapter.validate<PaginateCatalogProductInput>(PaginateCatalogProductSchema, object);

        return new CatalogProductPaginateDto(page, lim, search?.trim().toLowerCase(), category);
    }
}
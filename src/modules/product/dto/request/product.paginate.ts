import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateProductInput, PaginateProductSchema } from "../../schema/product.schema";

export class ProductPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): ProductPaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateProductInput>(PaginateProductSchema, object);

        return new ProductPaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
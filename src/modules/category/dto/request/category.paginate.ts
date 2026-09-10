import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateCategoryInput, PaginateCategorySchema } from "../../schema/category.schema";

export class CategoryPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): CategoryPaginateDto {
        
        const { page, lim, search } = ZodAdapter.validate<PaginateCategoryInput>(PaginateCategorySchema, object);

        return new CategoryPaginateDto(page, lim, search?.trim().toLowerCase());
    }
}
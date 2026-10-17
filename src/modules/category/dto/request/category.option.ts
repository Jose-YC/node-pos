import { ZodAdapter } from "../../../../shared";
import { OptionsCategoryInput, OptionsCategorySchema } from "../../schema/category.schema";

export class CategoryOptionsDto {

    private constructor(
        public readonly search?:string,
    ) {}   

    static create(object:{[key:string]:any}): CategoryOptionsDto {
        
        const { search } = ZodAdapter.validate<OptionsCategoryInput>(OptionsCategorySchema, object);

        return new CategoryOptionsDto(search);
    }
}
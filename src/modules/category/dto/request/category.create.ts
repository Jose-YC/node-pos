import { ZodAdapter } from "../../../../shared";
import { CreateCategoryInput, CreateCategorySchema } from "../../schema/category.schema";

export class CreateCategoryRequestDto {

    private constructor(
        public readonly name:string,
        public readonly description?:string,
    ){}

    static create(props: {[key:string]:any}): CreateCategoryRequestDto{
        
        const { name, description } = ZodAdapter.validate<CreateCategoryInput>(CreateCategorySchema, props);

        return new CreateCategoryRequestDto(name, description);
    }
}
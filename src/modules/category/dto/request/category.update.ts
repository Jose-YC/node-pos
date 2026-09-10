import { ZodAdapter } from "../../../../shared";
import { UpdateCategoryInput, UpdateCategorySchema } from "../../schema/category.schema";

export class UpdateCategoryRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
        public readonly description?:string,
    ){}

    get values(){
        const returnObj: {[key:string]: any}={}
        if (this.name) returnObj.name=this.name;
        if (this.description) returnObj.module=this.description;
        return returnObj;
    }

    static create(props: {[key:string]:any}): UpdateCategoryRequestDto{
        
        const { id, name, description } = ZodAdapter.validate<UpdateCategoryInput>(UpdateCategorySchema, {...props, id: Number(props.id) });
        
        return new UpdateCategoryRequestDto(id, name, description);
    }
}
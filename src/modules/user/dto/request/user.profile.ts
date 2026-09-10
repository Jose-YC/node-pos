import { ZodAdapter } from "../../../../shared";
import { UpdateProfileInput, UpdateProfileSchema } from "../../schema/user.schema";

export class UpdateProfileRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
    ){}

    get values(){
        const returnObj: {[key:string]: any}={}
        if (this.name) returnObj.name=this.name;
        return returnObj;
    }

    static create(props: {[key:string]:any}): UpdateProfileRequestDto{

        const { id, name } = ZodAdapter.validate<UpdateProfileInput>(UpdateProfileSchema, props);

        return new UpdateProfileRequestDto(id, name)
    }
}
import { ZodAdapter } from "../../../../shared";
import { UpdateUserInput, UpdateUserSchema } from "../../schema/user.schema";


export class UpdateUserRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
        public readonly email?:string,
        public readonly password?:string, 
        public readonly rol?:number[],
    ){}

    static create(props: {[key:string]:any}): UpdateUserRequestDto{
        const {id, email, name, password, rol} = ZodAdapter.validate<UpdateUserInput>(UpdateUserSchema, props);
 
        return new UpdateUserRequestDto(id, name, email, password, rol);
    }
}
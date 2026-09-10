import { ZodAdapter } from "../../../../shared";
import { CreateUserInput, CreateUserSchema } from "../../schema/user.schema";

export class CreateUserRequestDto {

    private constructor(
        public readonly email:string,
        public readonly name:string,
        public readonly password:string, 
        public readonly rol:number[],
    ){}

    static create(props: {[key:string]:any}): CreateUserRequestDto{
        const { email, name, password, rol } = ZodAdapter.validate<CreateUserInput>(CreateUserSchema, props);

        return new CreateUserRequestDto(email.trim(), name.trim(), password, rol) 
    }
}
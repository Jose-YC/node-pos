import { ZodAdapter } from "../../../../shared";
import { LoginRequestInput, LoginRequestSchema } from "../../schema/auth.schema";

export class LoginRequestDto {

    private constructor(
        public readonly email:string,
        public readonly password:string, 
    ){}

    static create(props: {[key:string]:any}): LoginRequestDto{

        const { email, password } = ZodAdapter.validate<LoginRequestInput>(LoginRequestSchema, props);

        return new LoginRequestDto(email, password);
    }
}
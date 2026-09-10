import { ZodAdapter } from "../../../../shared";
import { RegisterRequestInput, RegisterRequestSchema } from "../../schema/auth.schema";

export class RegisterRequestDto {

    private constructor(
        public readonly email:string,
        public readonly name:string,
        public readonly password:string, 
    ){}

    static create(props: {[key:string]:any}): RegisterRequestDto{

        const { email, password, name } = ZodAdapter.validate<RegisterRequestInput>(RegisterRequestSchema, props);
        
        return new RegisterRequestDto(email, name, password);
    }
}
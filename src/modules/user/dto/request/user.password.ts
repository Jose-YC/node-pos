import { ZodAdapter } from "../../../../shared";
import { UpdatePasswordInput, UpdatePasswordSchema } from "../../schema/user.schema";

export class UpdatePasswordRequestDto {

    private constructor(
        public readonly id:number, 
        public readonly password:string, 
        public readonly oldPassword:string, 
    ){}

    static create(props: {[key:string]:any}): UpdatePasswordRequestDto{
        const { newPassword, currentPassword, id } = ZodAdapter.validate<UpdatePasswordInput>(UpdatePasswordSchema, props);

        return new UpdatePasswordRequestDto(id, newPassword, currentPassword) 
    }
}
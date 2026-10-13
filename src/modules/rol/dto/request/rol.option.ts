import { ZodAdapter } from "../../../../shared";
import { OptionsRoleInput, OptionsRoleSchema } from "../../schema/rol.schema";

export class RoleOptionsDto {

    private constructor(
        public readonly search?:string,
    ) {}   

    static create(object:{[key:string]:any}): RoleOptionsDto {
        
        const { search } = ZodAdapter.validate<OptionsRoleInput>(OptionsRoleSchema, object);

        return new RoleOptionsDto(search);
    }
}   
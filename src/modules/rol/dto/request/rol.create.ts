import { ZodAdapter } from "../../../../shared";
import { CreateRoleInput, CreateRoleSchema } from "../../schema/rol.schema";

export class CreateRoleRequestDto {

    private constructor(
        public readonly name:string,
        public readonly description:string,
        public readonly permissions_id:number[],
    ){}

    static create(props: {[key:string]:any}): CreateRoleRequestDto{

        const { name, description, permissions } = ZodAdapter.validate<CreateRoleInput>(CreateRoleSchema, props);
        
        return new CreateRoleRequestDto(name, description,  permissions);
    }
}
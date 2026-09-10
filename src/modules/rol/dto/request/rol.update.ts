import { ZodAdapter } from "../../../../shared";
import { UpdateRoleInput, UpdateRoleSchema } from "../../schema/rol.schema";

export class UpdateRoleRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
        public readonly description?:string,
        public readonly permissions_id?:number[],
    ){}

    static create(props: {[key:string]:any}): UpdateRoleRequestDto{

        const { id, name, description, permissions } = ZodAdapter.validate<UpdateRoleInput>(UpdateRoleSchema, {...props, id: Number(props.id)});
        
        return new UpdateRoleRequestDto(id, name, description, permissions);
    }
}
import { ZodAdapter } from "../../../../shared";
import { UpdatePermissionInput, UpdatePermissionSchema } from "../../schema/permission.schema";

export class UpdatePermissionRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
        public readonly module?:string,
    ){}

    get values(){
        const returnObj: {[key:string]: any}={}
        if (this.name) returnObj.name=this.name;
        if (this.module) returnObj.module=this.module;
        return returnObj;
    }

    static create(props: {[key:string]:any}): UpdatePermissionRequestDto{
        
        const { id, name, module } = ZodAdapter.validate<UpdatePermissionInput>(UpdatePermissionSchema, {...props, id: Number(props.id) });
        
        return new UpdatePermissionRequestDto(id, name?.trim().toLowerCase(), module?.trim());
    }
}
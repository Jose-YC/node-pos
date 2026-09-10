import { ZodAdapter } from "../../../../shared";
import { CreatePermissionInput, CreatePermissionSchema } from "../../schema/permission.schema";

export class CreatePermissionRequestDto {

    private constructor(
        public readonly name:string,
        public readonly module:string,
    ){}

    static create(props: {[key:string]:any}): CreatePermissionRequestDto{
        
        const { name, module } = ZodAdapter.validate<CreatePermissionInput>(CreatePermissionSchema, props);

        return new CreatePermissionRequestDto(name, module);
    }
}
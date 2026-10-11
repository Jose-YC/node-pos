import { ZodAdapter } from "../../../../shared";
import { OptionsPermissionInput, OptionsPermissionSchema } from "../../schema/permission.schema";

export class PermissionOptionsDto {

    private constructor(
        public readonly search?:string,
    ) {}   

    static create(object:{[key:string]:any}): PermissionOptionsDto {
        
        const { search } = ZodAdapter.validate<OptionsPermissionInput>(OptionsPermissionSchema, object);

        return new PermissionOptionsDto(search);
    }
}
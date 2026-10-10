import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginatePermissionInput, PaginatePermissionSchema } from "../../schema/permission.schema";

export class PermissionPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly limit:number,
        public readonly search?:string,
    ) {
        super(page, limit, search);
    }   

    static create(object:{[key:string]:any}): PermissionPaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginatePermissionInput>(PaginatePermissionSchema, object);

        return new PermissionPaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginatePermissionInput, PaginatePermissionSchema } from "../../schema/permission.schema";

export class PermissionPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): PermissionPaginateDto {
        
        const { page, lim, search } = ZodAdapter.validate<PaginatePermissionInput>(PaginatePermissionSchema, object);

        return new PermissionPaginateDto(page, lim, search?.trim().toLowerCase());
    }
}
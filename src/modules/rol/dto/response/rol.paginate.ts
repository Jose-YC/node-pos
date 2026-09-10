import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateRolesInput, PaginateRolesSchema } from "../../schema/rol.schema";

export class RolePaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): RolePaginateDto {
        
        const { page, lim, search } = ZodAdapter.validate<PaginateRolesInput>(PaginateRolesSchema, object);

        return new RolePaginateDto(page, lim, search?.trim().toLowerCase());
    }
}
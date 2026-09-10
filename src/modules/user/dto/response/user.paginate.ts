import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateUserInput, PaginateUserSchema } from "../../schema/user.schema";

export class UserPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
        public readonly rol?:number,
    ) {
        super(page, lim, search);
    }   

    static create(option:{[key:string]:any}): UserPaginateDto {

        const { page, lim, search, rol } = ZodAdapter.validate<PaginateUserInput>(PaginateUserSchema, option);

        return new UserPaginateDto(page, lim, search, rol);
    }
}
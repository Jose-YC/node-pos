import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateBoxOpenInput, PaginateBoxOpenSchema } from "../../schema/box-open.schema";

export class BoxOpenPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): BoxOpenPaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateBoxOpenInput>(PaginateBoxOpenSchema, object);

        return new BoxOpenPaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateSaleInput, PaginateSaleSchema } from "../../schema/sale.schema";

export class SalePaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
        public readonly userid?:number,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): SalePaginateDto {
        
        const { page, lim, search, userid } = ZodAdapter.validate<PaginateSaleInput>(PaginateSaleSchema, object);

        return new SalePaginateDto(page, lim, search?.trim().toLowerCase(), userid);
    }
}
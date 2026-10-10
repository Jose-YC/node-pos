import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateSupplierInput, PaginateSupplierSchema } from "../../schema/supplier.schema";

export class SupplierPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): SupplierPaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateSupplierInput>(PaginateSupplierSchema, object);

        return new SupplierPaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
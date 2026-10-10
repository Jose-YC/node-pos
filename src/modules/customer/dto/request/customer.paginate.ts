import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateCustomerInput, PaginateCustomerSchema } from "../../schema/customer.schema";

export class CustomerPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): CustomerPaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateCustomerInput>(PaginateCustomerSchema, object);

        return new CustomerPaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
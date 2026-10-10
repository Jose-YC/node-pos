import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateOrderPurchaseInput, PaginateOrderPurchaseSchema } from "../../schema/order-purchase.schema";

export class OrderPurchasePaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): OrderPurchasePaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateOrderPurchaseInput>(PaginateOrderPurchaseSchema, object);

        return new OrderPurchasePaginateDto(page, limit, search);
    }
}
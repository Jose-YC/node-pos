import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateReceiptPurchaseInput, PaginateReceiptPurchaseSchema } from "../../schema/receipt-purchase.schema";

export class ReceiptPurchasePaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): ReceiptPurchasePaginateDto {
        
        const { page, lim, search } = ZodAdapter.validate<PaginateReceiptPurchaseInput>(PaginateReceiptPurchaseSchema, object);

        return new ReceiptPurchasePaginateDto(page, lim, search);
    }
}
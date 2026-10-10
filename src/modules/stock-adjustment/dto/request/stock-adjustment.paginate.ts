import { PaginateDto, ZodAdapter } from "../../../../shared";
import { PaginateStockAdjustmentInput, PaginateStockAdjustmentSchema } from "../../schema/stock-adjustment.schema";

export class StockAdjustmentPaginateDto extends PaginateDto {

    private constructor(
        public readonly page:number,
        public readonly lim:number,
        public readonly search?:string,
    ) {
        super(page, lim, search);
    }   

    static create(object:{[key:string]:any}): StockAdjustmentPaginateDto {
        
        const { page, limit, search } = ZodAdapter.validate<PaginateStockAdjustmentInput>(PaginateStockAdjustmentSchema, object);

        return new StockAdjustmentPaginateDto(page, limit, search?.trim().toLowerCase());
    }
}
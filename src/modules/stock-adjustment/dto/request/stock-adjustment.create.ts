import { ZodAdapter } from "../../../../shared";
import { CreateStockAdjustmentInput, CreateStockAdjustmentSchema } from "../../schema/stock-adjustment.schema";

interface itemsOrder {
    product_id:number
    qty: number
}

export class CreateStockAdjustmentRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly reason_id:number,
        public readonly items:itemsOrder[],
        public readonly notes?:string,
    ){}

    static create(props: {[key:string]:any}): CreateStockAdjustmentRequestDto{

        const { userid, reason_id, items, notes } = ZodAdapter.validate<CreateStockAdjustmentInput>(CreateStockAdjustmentSchema, props);

        return new CreateStockAdjustmentRequestDto(userid, reason_id, items, notes);
    }
}
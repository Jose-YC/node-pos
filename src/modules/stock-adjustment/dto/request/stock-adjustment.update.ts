import { ZodAdapter } from "../../../../shared";
import { UpdateStockAdjustmentInput, UpdateStockAdjustmentSchema } from "../../schema/stock-adjustment.schema";

interface itemsOrder {
    product_id:number
    qty: number
}

export class UpdateStockAdjustmentRequestDto {

    private constructor(
        public readonly id:number,
        public readonly reason_id?:number,
        public readonly items?:itemsOrder[],
        public readonly notes?:string,
    ){}

    static create(props: {[key:string]:any}): UpdateStockAdjustmentRequestDto{

        const {id, reason_id, items, notes } = ZodAdapter.validate<UpdateStockAdjustmentInput>(UpdateStockAdjustmentSchema, props);

        return new UpdateStockAdjustmentRequestDto(id, reason_id, items, notes);
    }
}
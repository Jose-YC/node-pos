import { ZodAdapter } from "../../../../shared";
import { UpdateProductInput, UpdateProductSchema } from "../../schema/product.schema";

export class UpdateProductRequestDto {

    private constructor(
        public readonly id:number,
        public readonly name?:string,
        public readonly description?:string,
        public readonly category_id?:number,
        public readonly min_order_qty?:number,
        public readonly min_stock_qty?:number,
    ){}

    static create(props: {[key:string]:any}): UpdateProductRequestDto{
        
        const { id, name, description, category_id, min_order_qty, min_stock_qty } = ZodAdapter.validate<UpdateProductInput>(UpdateProductSchema, {...props, id: Number(props.id) });
        
        return new UpdateProductRequestDto(id, name, description, category_id, min_order_qty, min_stock_qty);
    }
}
import { ZodAdapter } from "../../../../shared";
import { CreateProductInput, CreateProductSchema } from "../../schema/product.schema";

export class CreateProductRequestDto {

    private constructor(
        public readonly name:string,
        public readonly description:string,
        public readonly image:string,
        public readonly category_id:number,
        public readonly min_order_qty:number,
        public readonly min_stock_qty:number,
        public readonly status:boolean,
        public readonly price_buying:number,
        public readonly price_selling:number,
    ){}

    static create(props: {[key:string]:any}): CreateProductRequestDto{
        
        const { name, description, image, category_id, min_order_qty, min_stock_qty, status, price_buying, price_selling } = ZodAdapter.validate<CreateProductInput>(CreateProductSchema, props);

        return new CreateProductRequestDto(name, description, image, category_id, min_order_qty, min_stock_qty, status, price_buying, price_selling);
    }
}
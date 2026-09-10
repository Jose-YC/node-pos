export class ProductResponseDto {

    constructor(
        public id:number,
        public sku:string,
        public name:string,
        public description:string,
        public image:string,
        public category_name:string,
        public min_order_qty:number,
        public min_stock:number,
        public status:boolean,
    ){}
}
interface Category {
    id: number,
    name: string
}

export class ProductByIdResponseDto {

    constructor(
        public id:number,
        public sku:string,
        public name:string,
        public description:string,
        public image:string,
        public category:Category,
        public min_order_qty:number,
        public min_stock:number,
        public status:boolean,
        public stock:number,
        public price_buying:number,
        public price_selling:number,
    ){}
}
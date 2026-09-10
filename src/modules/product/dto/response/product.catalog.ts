export class CatalogProductResponseDto {

    constructor(
        public id:number,
        public name:string,
        public image:string,
        public category_name:string,
        public stock:number,
        public price:number,
    ){}
}
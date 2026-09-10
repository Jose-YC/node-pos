export class BoxOpenListItemDto {
    constructor(
        public id:number,
        public serie:string,
        public status:string,
        public start:Date,
        public end:Date,
    ){}
}
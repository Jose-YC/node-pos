
export abstract class PaginateDto {

    protected constructor(
        public page:number,
        public limit:number,
        public search?:string,
    ){}
}
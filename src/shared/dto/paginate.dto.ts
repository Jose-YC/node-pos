
export abstract class PaginateDto {

    protected constructor(
        public page:number,
        public lim:number,
        public search?:string,
    ){}
}
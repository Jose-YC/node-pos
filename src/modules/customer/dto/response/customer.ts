export class CustomerResponseDto {
    constructor(
        public id:number,
        public name:string,
        public doc_type:string,
        public doc_code:string,
        public doc_number:string,
        public email?:string,
        public phone?:string,
    ){}
}
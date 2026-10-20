export class IdentityDocumentTypeResponseDto {

    constructor(
        public id:string,
        public name:string,
        public code:string,
        public short_name:string,
        public status:boolean,
    ){}
}
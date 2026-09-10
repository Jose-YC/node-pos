export class UserListItemDto {

    constructor(
        public id:number,
        public email:string,
        public name:string,
        public img?:string,
    ){}
}
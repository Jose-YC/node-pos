export class UserPermissionsResponseDto {

    constructor(
        public id:number,
        public email:string,
        public name:string,
        public permissions:string[],
        // public img?:string,
    ){}
}
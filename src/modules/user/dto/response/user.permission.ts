export class UserPermissionsResponseDto {

    constructor(
        public id:number,
        public permissions:string[],
    ){}
}
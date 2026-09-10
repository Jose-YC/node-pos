export class RoleListItemDto {

    constructor(
        public id:number,
        public name:string,
        public count_permissions:number,
        public description?:string,
    ){}
}
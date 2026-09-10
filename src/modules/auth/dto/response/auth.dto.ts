import { UserListItemDto } from "../../../user/dto";

export class AuthResponseDto {

    constructor(
        public token:string,
        public user:UserListItemDto,

    ){}
}
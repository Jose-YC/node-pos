export interface UserRole {
    id: number;
    name: string;
}

export class UserResponseDto {

    constructor(
        public id:number,
        public email:string,
        public name:string,
        public rol:UserRole[],
        public img?:string,
    ){}
}
import { ZodAdapter } from "../../../../shared";
import { CreateBoxOpenInput, CreateBoxOpenSchema } from "../../schema/box-open.schema";

export class CreateBoxOpenRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly amount_cash:number,
        public readonly note?:string
    ){}

    static create(props: {[key:string]:any}): CreateBoxOpenRequestDto{

        const { amount, userid, note } = ZodAdapter.validate<CreateBoxOpenInput>(CreateBoxOpenSchema, props);
        
        return new CreateBoxOpenRequestDto(userid, amount, note);
    }
}
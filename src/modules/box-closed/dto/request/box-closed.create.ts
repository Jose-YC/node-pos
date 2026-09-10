import { ZodAdapter } from "../../../../shared";
import { CreateBoxClosedInput, CreateBoxClosedSchema } from "../../schema/box-closed.schema";

export class CreateBoxClosedRequestDto {

    private constructor(
        public readonly userid:number,
        public readonly box_open_id:number,
        public readonly amount_cash:number,
        public readonly note?:string
    ){}

    static create(props: {[key:string]:any}): CreateBoxClosedRequestDto{

        const { amount_cash, userid, box_open_id, note } = ZodAdapter.validate<CreateBoxClosedInput>(CreateBoxClosedSchema, props);
        
        return new CreateBoxClosedRequestDto(userid, box_open_id, amount_cash, note);
    }
}
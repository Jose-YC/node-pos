import { ZodAdapter } from "../../../../shared";
import { CreateUploadUrlInput, CreateUploadUrlSchema } from "../../schema/image.schema";
import { modules } from "../../utils/enum/image.enum";

export class CreateUploadUrlDto {
    
    constructor(
        public readonly name: string,
        public readonly userid: number,
        public readonly type: modules
    ){}

    static create(props: {[key:string]:any}): CreateUploadUrlDto{

        const { name, userid, type } = ZodAdapter.validate<CreateUploadUrlInput>(CreateUploadUrlSchema, {
            name: props.name,
            userid: props.userid,
            type: props.type
        });

        return new CreateUploadUrlDto(
            name, 
            userid, 
            type
        );
    }


}
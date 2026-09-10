import { ZodAdapter } from "../../../../shared";
import { UpdateImageSchema, UpdateImageInput} from "../../schema/user.schema";

export class UpdateImageRequestDto {

    private constructor(
        public readonly id:number,
        public readonly image:string,
    ){}

    static create(props: {[key:string]:any}): UpdateImageRequestDto{

        const { id, image } = ZodAdapter.validate<UpdateImageInput>(UpdateImageSchema, props);

        return new UpdateImageRequestDto(id, image)
    }
}
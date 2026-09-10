import { ZodAdapter } from "../../../../shared";
import { UpdateImageSchema, UpdateImageInput} from "../../schema/product.schema";

export class UpdateProductImageRequestDto {

    private constructor(
        public readonly id:number,
        public readonly image:string,
    ){}

    static create(props: {[key:string]:any}): UpdateProductImageRequestDto{

        const { id, image } = ZodAdapter.validate<UpdateImageInput>(UpdateImageSchema, props);

        return new UpdateProductImageRequestDto(id, image)
    }
}
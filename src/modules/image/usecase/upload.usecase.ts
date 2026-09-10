import { ImageDatasource } from "../datasource/image.datasource";
import { ImageUrlDto, CreateUploadUrlDto } from "../dto";

export class CreateUploadUrlUsecase {

    public async execute(options: CreateUploadUrlDto): Promise<ImageUrlDto> {
        return await new ImageDatasource().upload(options);
    }
}
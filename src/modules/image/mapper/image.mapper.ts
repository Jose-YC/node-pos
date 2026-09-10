import { ImageUrlDto } from "../dto";

interface ImageRaw {
    url: string
    signature: string
    apiKey: string
    cloud_name: string
    timestamp: number
    folder: string
    public_id: string
}

export class ImageMapper {
    static toResponseDto(image: ImageRaw): ImageUrlDto {
      return {
        url: image.url,
        signature: image.signature,
        api_key: image.apiKey,
        cloud_name: image.cloud_name,
        timestamp: image.timestamp,
        folder: image.folder,
        public_id: image.public_id,
      };
    }
}
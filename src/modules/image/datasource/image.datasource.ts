import { env } from "../../../config";
import { ClaudinaryAdapter } from "../../../shared/adapters/claudinary.adapter";
import { CreateUploadUrlDto } from "../dto";
import { ImageMapper } from "../mapper/image.mapper";
import { police } from "../utils/enum/image.enum";

export class ImageDatasource {

    upload( create: CreateUploadUrlDto ){
        const publicid = police[create.type].publicid(create.userid, create.name);
        const folder = `${env.CLOUDINARY_UPLOAD_FOLDER}/users`;
        const timestamp = Math.floor(new Date().getTime() / 1000)

        const signature = new ClaudinaryAdapter().UploadUrl(publicid, folder, timestamp);
        
        return ImageMapper.toResponseDto({ 
            url: `https://api.cloudinary.com/v1_1/${env.CLOUDINARY_CLOUD_NAME}/image/upload`,
            signature, 
            apiKey: env.CLOUDINARY_API_KEY,
            cloud_name: env.CLOUDINARY_CLOUD_NAME,
            timestamp, 
            folder,
            public_id: publicid,
        });
    }
}
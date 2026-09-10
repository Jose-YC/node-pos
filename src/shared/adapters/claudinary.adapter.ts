import { v2 as claudinary } from 'cloudinary';
import { env } from '../../config';


export class ClaudinaryAdapter {

    constructor(){
        claudinary.config({
            cloud_name: env.CLOUDINARY_CLOUD_NAME,
            api_key: env.CLOUDINARY_API_KEY,
            api_secret: env.CLOUDINARY_API_SECRET,
        });
    }

    UploadUrl(publicid: string, folder: string, timestamp: number): string {
        const signature = claudinary.utils.api_sign_request(
            {
                timestamp, 
                folder,
                public_id: publicid,
                unique_filename: false
            },
            env.CLOUDINARY_API_SECRET,
        );

        return signature;
    }
}
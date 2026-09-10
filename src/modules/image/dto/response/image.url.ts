

export class ImageUrlDto {

    constructor(
        public readonly url: string,
        public readonly signature: string,
        public readonly api_key: string,
        public readonly cloud_name: string,
        public readonly timestamp: number,
        public readonly folder: string,
        public readonly public_id: string,
    ){}
}
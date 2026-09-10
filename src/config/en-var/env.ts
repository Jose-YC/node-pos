import 'dotenv/config';
import { get } from 'env-var';

const NODE_ENV = get('NODE_ENV').required().asEnum(['development', 'production', 'test']);

const getEnv  = () => {

  if (NODE_ENV === 'production' || NODE_ENV === 'test') return {};

  return {
    POSTGRES_PASSWORD: get('POSTGRES_PASSWORD').required().asString(),
    POSTGRES_USER: get('POSTGRES_USER').required().asString(),
    POSTGRES_DB: get('POSTGRES_DB').required().asString(),
    PGADMIN_DEFAULT_EMAIL: get('PGADMIN_DEFAULT_EMAIL').required().asString(),
    PGADMIN_DEFAULT_PASSWORD: get('PGADMIN_DEFAULT_PASSWORD').required().asString(),
  }
}

export const env = {
    NODE_ENV,
    DATABASE_URL: get('DATABASE_URL').required().asString(),
    JWT_SECRET: get('JWT_SECRET').required().asString(),
    PORT: get('PORT').required().asPortNumber(),
    CLOUDINARY_CLOUD_NAME: get('CLOUDINARY_CLOUD_NAME').required().asString(),
    CLOUDINARY_API_KEY: get('CLOUDINARY_API_KEY').required().asString(),
    CLOUDINARY_API_SECRET: get('CLOUDINARY_API_SECRET').required().asString(),
    CLOUDINARY_UPLOAD_FOLDER: get('CLOUDINARY_UPLOAD_FOLDER').required().asString(),
    ...getEnv ()
}
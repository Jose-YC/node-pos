import { HttpStatusCode } from "../../utils";


export class CustomError extends Error {

    constructor(
        public readonly name:string,
        public readonly httpCode:HttpStatusCode,
        public readonly message:string,
        public readonly isOperational: boolean = true
    ){
        super(message);
        Object.setPrototypeOf(this, new.target.prototype);
        Error.captureStackTrace?.(this, CustomError);
    }

    static badRequest( message:string ){
        return new CustomError('BAD_REQUEST', HttpStatusCode.BAD_REQUEST, message);
    }

    static unAuthorized( message:string ){
        return new CustomError('UN_AUTHORIZED', HttpStatusCode.UN_AUTHORIZED, message);
    }

    static forbidden( message:string ){
        return new CustomError('FOR_BIDDEN', HttpStatusCode.FOR_BIDDEN, message);
    }

    static notFound( message:string ){
        return new CustomError('NOT_FOUND', HttpStatusCode.NOT_FOUND, message);
    }

    static internalServer( message:string ){
        return new CustomError('INTERNAL_SERVER_ERROR', HttpStatusCode.INTERNAL_SERVER_ERROR, message, false);
    }

}
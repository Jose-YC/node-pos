import { Request, Response } from "express";
import { catchAsync, errorHandler, CustomError } from "../../../shared";
import { ListIdentityDocumentTypeUsecase,ListOptionsIdentityDocumentTypeUsecase, StatusIdentityDocumentTypeUsecase } from "../usecase";
import { IdentityDocumentTypePaginateDto } from "../dto";

export class IdentityDocumentTypeController { 
    public status = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id || Array.isArray(id)) throw CustomError.badRequest("Missing id");
        
        new StatusIdentityDocumentTypeUsecase().execute(id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    });

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, limit = 5, search } = req.query;
        const paginate = IdentityDocumentTypePaginateDto.create( {page: +page, limit: +limit, search});
                
        new ListIdentityDocumentTypeUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    });

    public options = catchAsync((req:Request, res:Response) =>  {
        new ListOptionsIdentityDocumentTypeUsecase().execute()
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    });     
}
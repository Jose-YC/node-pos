import { Request, Response } from "express";
import { catchAsync, CustomError, errorHandler } from "../../../shared";
import { ListTypeDocumentSaleUsecase, ListOptionsTypeDocumentSaleUsecase, StatusTypeDocumentSaleUsecase } from "../usecase";
import { TypeDocumentSalePaginateDto } from "../dto";

export class TypeDocumentSaleController { 
    public status = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id || Array.isArray(id)) throw CustomError.badRequest("Missing id");
        
        new StatusTypeDocumentSaleUsecase().execute(id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, limit = 5, search } = req.query;
        const paginate= TypeDocumentSalePaginateDto.create( {page: +page, limit: +limit, search});
        
        new ListTypeDocumentSaleUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public options = catchAsync((req:Request, res:Response) =>  {
        new ListOptionsTypeDocumentSaleUsecase().execute()
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })
}
import { Request, Response } from "express";
import { catchAsync, CustomError, errorHandler } from "../../../shared";
import { ListTypeDocumentSaleUsecase, ListTypeDocumentSaleStatusUsecase, StatusTypeDocumentSaleUsecase } from "../usecase";

export class TypeDocumentSaleController { 
    public status = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        
        if (!id || Array.isArray(id)) {
            throw CustomError.badRequest("Missing id");
        }

        new StatusTypeDocumentSaleUsecase().execute(id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public getAll = catchAsync((req:Request, res:Response) =>  {
        new ListTypeDocumentSaleUsecase().execute()
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public getStatus = catchAsync((req:Request, res:Response) =>  {
        new ListTypeDocumentSaleStatusUsecase().execute()
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })
}
import { Request, Response } from "express";
import { catchAsync, errorHandler } from "../../../shared";
import { ListIdentityDocumentTypeUsecase } from "../usecase/list.usecase";

export class IdentityDocumentTypeController { 
    public get = catchAsync((req:Request, res:Response) =>  {
        new ListIdentityDocumentTypeUsecase().execute()
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })
}
import { Request, Response } from "express";

import { CreateUploadUrlUsecase } from "../usecase/upload.usecase";
import { catchAsync, CustomError, errorHandler, userContextManager } from "../../../shared";
import { CreateUploadUrlDto } from "../dto";

export class ImageController {

    public upload = catchAsync((req:Request, res:Response) =>  {
        const id  = userContextManager.getValue('id');
        if (!id) throw CustomError.unAuthorized("Not logged in");

        const create = CreateUploadUrlDto.create({...req.body, userid: id});

        new CreateUploadUrlUsecase().execute(create)
        .then((dto) => res.status(201).json({ status: true, code: 201, message: 'ok', data: dto }))
        .catch((err) => errorHandler(err, res));
    })
}
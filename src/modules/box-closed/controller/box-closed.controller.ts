import { Response, Request } from 'express'

import { ByIdBoxClosedUsecase, ClosedBoxUsecase } from '../usecase';
import { catchAsync, CustomError, errorHandler, userContextManager } from '../../../shared';
import { CreateBoxClosedRequestDto } from '../dto';

export class BoxClosedController { 
    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = +req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdBoxClosedUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public closed = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        const create = CreateBoxClosedRequestDto.create({...req.body, userid});

        new ClosedBoxUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })
}
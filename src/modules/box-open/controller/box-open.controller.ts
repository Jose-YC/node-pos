import { Response, Request } from 'express'

import { ListBoxOpenUsecase, OpenBoxUsecase } from '../usecase';
import { catchAsync, CustomError, errorHandler, userContextManager } from '../../../shared';
import { CreateBoxOpenRequestDto, BoxOpenPaginateDto } from '../dto';

export class BoxOpenController { 

    public open = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        const create = CreateBoxOpenRequestDto.create({...req.body, userid});

        new OpenBoxUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, lim = 5, search } = req.query;
        const paginate= BoxOpenPaginateDto.create( {page: +page, lim: +lim, search});

        new ListBoxOpenUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })
}
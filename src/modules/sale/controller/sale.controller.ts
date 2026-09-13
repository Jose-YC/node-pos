import { Response, Request } from 'express'

import { CreateSaleUsecase, ListSaleUsecase, CreateCreditNoteUsecase, ByIdSaleUsecase } from '../usecase';
import { catchAsync, CustomError, errorHandler, userContextManager } from '../../../shared';
import { CreateSaleRequestDto, SalePaginateDto, CreateCreditNoteRequestDto } from '../dto';

export class SaleController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        if (!userid) throw CustomError.unAuthorized("Not logged in");
        
        const create = CreateSaleRequestDto.create({ ...req.body, userid });

        new CreateSaleUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })

    public postCreditNote = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        if (!userid) throw CustomError.unAuthorized("Not logged in");
        
        const create = CreateCreditNoteRequestDto.create({ ...req.body, userid });

        new CreateCreditNoteUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })

    public getAll = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, lim = 5, search, user } = req.query;
        const paginate= SalePaginateDto.create( {page: +page, lim: +lim, search, userid: user ? +user : undefined } );

        new ListSaleUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public getAllById = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, lim = 5, search } = req.query;
        
        const userid  = userContextManager.getValue('id');
        if (!userid) throw CustomError.unAuthorized("Not logged in");

        const paginate= SalePaginateDto.create( {page: +page, lim: +lim, search, userid});

        new ListSaleUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = +req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdSaleUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })
}
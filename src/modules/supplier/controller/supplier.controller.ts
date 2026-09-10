import { Request, Response } from "express";
import { CreateSupplierUsecase, ListSupplierUsecase, ByIdSupplierUsecase, UpdateSupplierUsecase, DeleteSupplierUsecase } from "../usecase";
import { CreateSupplierRequestDto, SupplierPaginateDto, UpdateSupplierRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";

export class SupplierController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateSupplierRequestDto.create(req.body);

        new CreateSupplierUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = SupplierPaginateDto.create( {page: +page, lim: +lim, search});

        new ListSupplierUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdSupplierUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateSupplierRequestDto.create({...req.body, id: +id});

        new UpdateSupplierUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteSupplierUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
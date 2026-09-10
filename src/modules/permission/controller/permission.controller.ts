import { Request, Response } from "express";
import { CreatePermissionUsecase, ListPermissionUsecase, ByIdPermissionUsecase, UpdatePermissionUsecase, DeletePermissionUsecase } from "../usecase";
import { CreatePermissionRequestDto, PermissionPaginateDto, UpdatePermissionRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";

export class PermissionController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreatePermissionRequestDto.create(req.body);

        new CreatePermissionUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = PermissionPaginateDto.create( {page: +page, lim: +lim, search});

        new ListPermissionUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdPermissionUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdatePermissionRequestDto.create({...req.body, id: +id});

        new UpdatePermissionUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeletePermissionUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
import { Response, Request } from 'express'

import { ListRolUsecase, CreateRolUsecase, ByIdRolUsecase, UpdateRolUsecase, DeleteRolUsecase } from '../usecase';
import { catchAsync, CustomError, errorHandler } from '../../../shared';
import { CreateRoleRequestDto, RolePaginateDto, UpdateRoleRequestDto } from '../dto';

export class RoleController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateRoleRequestDto.create(req.body);

        new CreateRolUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, lim = 5, search } = req.query;
        const paginate= RolePaginateDto.create( {page: +page, lim: +lim, search});

        new ListRolUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = +req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdRolUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = +req.params.id;
        const update = UpdateRoleRequestDto.create({...req.body, id});

        new UpdateRolUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = +req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteRolUsecase().execute(id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));
    })
}
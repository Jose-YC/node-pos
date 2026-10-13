import { Response, Request } from 'express'

import { ListRolUsecase, CreateRolUsecase, ByIdRolUsecase, UpdateRolUsecase, DeleteRolUsecase, ListOptionsRoleUsecase } from '../usecase';
import { catchAsync, CustomError, errorHandler } from '../../../shared';
import { CreateRoleRequestDto, RolePaginateDto, UpdateRoleRequestDto } from '../dto';
import { RoleOptionsDto } from '../dto/request/rol.option';

export class RoleController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateRoleRequestDto.create(req.body);

        new CreateRolUsecase().execute(create)
        .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 0, limit = 5, search } = req.query;
        const paginate= RolePaginateDto.create( {page: +page, limit: +limit, search});

        new ListRolUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public options = catchAsync((req:Request, res:Response) =>  {
        const { search } = req.query;
        const paginate = RoleOptionsDto.create( { search });

        new ListOptionsRoleUsecase().execute(paginate)
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
        .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = +req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteRolUsecase().execute(id)
        .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })
}
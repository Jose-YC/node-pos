import { Request, Response } from "express";
import { CreateCategoryUsecase, ListCategoryUsecase, ByIdCategoryUsecase, UpdateCategoryUsecase, DeleteCategoryUsecase } from "../usecase";
import { CreateCategoryRequestDto, CategoryPaginateDto, UpdateCategoryRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";

export class CategoryController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateCategoryRequestDto.create(req.body);

        new CreateCategoryUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = CategoryPaginateDto.create( {page: +page, lim: +lim, search});

        new ListCategoryUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdCategoryUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateCategoryRequestDto.create({...req.body, id: +id});

        new UpdateCategoryUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteCategoryUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
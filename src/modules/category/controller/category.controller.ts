import { Request, Response } from "express";
import { CreateCategoryUsecase, ListCategoryUsecase, ByIdCategoryUsecase, UpdateCategoryUsecase, DeleteCategoryUsecase, ListOptionsCategoryUsecase } from "../usecase";
import { CreateCategoryRequestDto, CategoryPaginateDto, UpdateCategoryRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";
import { CategoryOptionsDto } from "../dto/request/category.option";

export class CategoryController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateCategoryRequestDto.create(req.body);

        new CreateCategoryUsecase().execute(create)
        .then((data) => res.status(201).json({ status: true, code: 201, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, limit = 5, search } = req.query;
        const paginate = CategoryPaginateDto.create( {page: +page, limit: +limit, search});

        new ListCategoryUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public options = catchAsync((req:Request, res:Response) =>  {
        const { search } = req.query;
        const paginate = CategoryOptionsDto.create( { search });

        new ListOptionsCategoryUsecase().execute(paginate)
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
        .then((data) => res.status(201).json({ status: true, code: 201, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteCategoryUsecase().execute(+id)
        .then((data) => res.status(201).json({ status: true, code: 201, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })
}
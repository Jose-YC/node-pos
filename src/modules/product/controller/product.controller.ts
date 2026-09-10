import { Request, Response } from "express";
import { CreateProductUsecase, ListProductUsecase, ListCatalogProductUsecase, ByIdProductUsecase, UpdateProductUsecase, StatusProductUsecase, DeleteProductUsecase, ImageProductUsecase } from "../usecase";
import { CreateProductRequestDto, ProductPaginateDto, UpdateProductRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";
import { UpdateProductImageRequestDto } from "../dto/request/product.image";

export class ProductController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateProductRequestDto.create(req.body);

        new CreateProductUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = ProductPaginateDto.create( {page: +page, lim: +lim, search});

        new ListProductUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getCatalog = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search, category } = req.query;
        const paginate = ProductPaginateDto.create( {page: +page, lim: +lim, search, category: category ? +category : undefined });

        new ListCatalogProductUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdProductUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateProductRequestDto.create({...req.body, id: +id});

        new UpdateProductUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public status = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new StatusProductUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public image = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');
        
        const updateImage = UpdateProductImageRequestDto.create({ ...req.body, id: +id });

        new ImageProductUsecase().execute(updateImage)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteProductUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
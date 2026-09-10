import { Request, Response } from "express";
import { CreateCustomerUsecase, ListCustomerUsecase, ByIdCustomerUsecase, UpdateCustomerUsecase, DeleteCustomerUsecase } from "../usecase";
import { CreateCustomerRequestDto, CustomerPaginateDto, UpdateCustomerRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";

export class CustomerController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreateCustomerRequestDto.create(req.body);

        new CreateCustomerUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = CustomerPaginateDto.create( {page: +page, lim: +lim, search});

        new ListCustomerUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdCustomerUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateCustomerRequestDto.create({...req.body, id: +id});

        new UpdateCustomerUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteCustomerUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
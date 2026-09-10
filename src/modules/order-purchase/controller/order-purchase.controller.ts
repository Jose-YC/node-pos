import { Request, Response } from "express";
import { CreateOrderPurchaseUsecase, ListOrderPurchaseUsecase, 
         SendOrderPurchaseUsecase, SubmitOrderPurchaseUsecase, 
         ByIdOrderPurchaseUsecase, DraftOrderPurchaseUsecase, 
         UpdateOrderPurchaseUsecase, DeleteOrderPurchaseUsecase 
        } from "../usecase";
import { CreateOrderPurchaseRequestDto, OrderPurchasePaginateDto, UpdateOrderPurchaseRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler, userContextManager } from "../../../shared";

export class OrderPurchaseController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        if (!userid) throw CustomError.unAuthorized("Not logged in");

        const create = CreateOrderPurchaseRequestDto.create({...req.body, userid});

        new CreateOrderPurchaseUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = OrderPurchasePaginateDto.create( {page: +page, lim: +lim, search});

        new ListOrderPurchaseUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdOrderPurchaseUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateOrderPurchaseRequestDto.create({...req.body, id: +id});

        new UpdateOrderPurchaseUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public draft = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DraftOrderPurchaseUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })      

    public send = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new SendOrderPurchaseUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public submit = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new SubmitOrderPurchaseUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteOrderPurchaseUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
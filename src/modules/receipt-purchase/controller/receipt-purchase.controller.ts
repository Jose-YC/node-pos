import { Request, Response } from "express";
import { CreateReceiptPurchaseUsecase, ListReceiptPurchaseUsecase, SubmitReceiptPurchaseUsecase,
     ByIdReceiptPurchaseUsecase, UpdateReceiptPurchaseUsecase, DeleteReceiptPurchaseUsecase } from "../usecase";
import { CreateReceiptPurchaseRequestDto, ReceiptPurchasePaginateDto, UpdateReceiptPurchaseRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler, userContextManager } from "../../../shared";

export class ReceiptPurchaseController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        if (!userid) throw CustomError.unAuthorized("Not logged in");

        const create = CreateReceiptPurchaseRequestDto.create({...req.body, userid});

        new CreateReceiptPurchaseUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = ReceiptPurchasePaginateDto.create( {page: +page, lim: +lim, search});

        new ListReceiptPurchaseUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdReceiptPurchaseUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateReceiptPurchaseRequestDto.create({...req.body, id: +id});

        new UpdateReceiptPurchaseUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public submit = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new SubmitReceiptPurchaseUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteReceiptPurchaseUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
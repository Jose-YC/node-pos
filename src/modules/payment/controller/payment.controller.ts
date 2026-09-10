import { Request, Response } from "express";
import { CreatePaymentUsecase, ListPaymentUsecase, ByIdPaymentUsecase, UpdatePaymentUsecase, DeletePaymentUsecase, StatusPaymentUsecase } from "../usecase";
import { CreatePaymentRequestDto, PaymentPaginateDto, UpdatePaymentRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";

export class PaymentController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreatePaymentRequestDto.create(req.body);

        new CreatePaymentUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = PaymentPaginateDto.create( {page: +page, lim: +lim, search});

        new ListPaymentUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdPaymentUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdatePaymentRequestDto.create({...req.body, id: +id});

        new UpdatePaymentUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public status = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new StatusPaymentUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeletePaymentUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
import { Request, Response } from "express";
import { CreatePaymentUsecase, ListPaymentUsecase, ByIdPaymentUsecase, UpdatePaymentUsecase, DeletePaymentUsecase, StatusPaymentUsecase, ListOptionsPaymentUsecase } from "../usecase";
import { CreatePaymentRequestDto, PaymentPaginateDto, UpdatePaymentRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler } from "../../../shared";
import { PaymentOptionsDto } from "../dto/request/payment.option";

export class PaymentController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const create = CreatePaymentRequestDto.create(req.body);

        new CreatePaymentUsecase().execute(create)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, limit = 5, search } = req.query;
        const paginate = PaymentPaginateDto.create( {page: +page, limit: +limit, search});

        new ListPaymentUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public options = catchAsync((req:Request, res:Response) =>  {
        const { search } = req.query;
        const paginate = PaymentOptionsDto.create( { search });

        new ListOptionsPaymentUsecase().execute(paginate)
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
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public status = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new StatusPaymentUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeletePaymentUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })
}
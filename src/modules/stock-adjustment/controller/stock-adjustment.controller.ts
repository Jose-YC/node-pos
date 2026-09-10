import { Request, Response } from "express";
import { CreateStockAdjustmentUsecase, ListStockAdjustmentUsecase, SubmitStockAdjustmentUsecase,
    // ByIdStockAdjustmentUsecase, 
    UpdateStockAdjustmentUsecase, DeleteStockAdjustmentUsecase, 
    ByIdStockAdjustmentUsecase} from "../usecase";
import { CreateStockAdjustmentRequestDto, StockAdjustmentPaginateDto, UpdateStockAdjustmentRequestDto } from "../dto";
import { catchAsync, CustomError, errorHandler, userContextManager } from "../../../shared";

export class StockAdjustmentController { 

    public post = catchAsync((req:Request, res:Response) =>  {
        const userid  = userContextManager.getValue('id');
        if (!userid) throw CustomError.unAuthorized("Not logged in");

        const create = CreateStockAdjustmentRequestDto.create({...req.body, userid});

        new CreateStockAdjustmentUsecase().execute(create)
        .then((status) => res.status(201).json({ status, code: 201, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public get = catchAsync((req:Request, res:Response) =>  {
        const {  page = 1, lim = 5, search } = req.query;
        const paginate = StockAdjustmentPaginateDto.create( {page: +page, lim: +lim, search});

        new ListStockAdjustmentUsecase().execute(paginate)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));

    })

    public getId = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new ByIdStockAdjustmentUsecase().execute(+id)
        .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public put = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        const update = UpdateStockAdjustmentRequestDto.create({...req.body, id: +id});

        new UpdateStockAdjustmentUsecase().execute(update)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public submit = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new SubmitStockAdjustmentUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })

    public delete = catchAsync((req:Request, res:Response) =>  {
        const id = req.params.id;
        if (!id) throw CustomError.badRequest('Missing id');

        new DeleteStockAdjustmentUsecase().execute(+id)
        .then((status) => res.status(200).json({ status, code: 200, message: 'ok' }))
        .catch((err) => errorHandler(err, res));

    })
}
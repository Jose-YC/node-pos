import { Response, Request } from "express";

import {
  CreateUserRequestDto,
  UpdateImageRequestDto,
  UpdatePasswordRequestDto,
  UpdateProfileRequestDto,
  UpdateUserRequestDto,
  UserPaginateDto,
} from "../dto";
import { catchAsync, userContextManager,CustomError, errorHandler, jwtAdapter } from "../../../shared";
import { CreateUserUsecase, ListUserUsecase, ByIdUserUsecase, UpdateUserUsecase, ProfileUserUsecase, UpdatePasswordUserUsecase, DeleteUserUsecase, ImageUserUsecase, UserPermissionUsecase } from "../usecase";
import { extractJWT } from "../../../middlewares";

export class UserController {
  
  public post = catchAsync((req: Request, res: Response) => {
    const create = CreateUserRequestDto.create(req.body);

    new CreateUserUsecase()
      .execute(create)
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public get = catchAsync((req: Request, res: Response) => {
    const { page = 0, lim = 5, search, rol } = req.query;
    const paginate = UserPaginateDto.create({ page: +page, lim: +lim, search, rol: rol ? +rol : undefined });

    new ListUserUsecase()
      .execute(paginate)
      .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public getId = catchAsync((req: Request, res: Response) => {
    const id = +req.params.id;
    if (!id) throw CustomError.badRequest("Missing id");

    new ByIdUserUsecase()
      .execute(+id)
      .then((data) => res.status(200).json({ status:true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public put = catchAsync((req: Request, res: Response) => {
    const id = +req.params.id;
    const update = UpdateUserRequestDto.create({ ...req.body, id });

    new UpdateUserUsecase()
      .execute(update)
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public permission = catchAsync((req: Request, res: Response) => {
    const token = extractJWT(req);
    if (!token) throw CustomError.unAuthorized("No token provided");

      jwtAdapter.validatetJWT<{ id: number }>(token)
      .then((payload) => {
        if (!payload?.id) throw CustomError.unAuthorized("Unauthorized");

        return new UserPermissionUsecase().execute(payload.id);
      })
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public profile = catchAsync((req: Request, res: Response) => {
    const id  = userContextManager.getValue('id');
    if (!id) throw CustomError.unAuthorized("Not logged in");

    const updateProfile = UpdateProfileRequestDto.create({ ...req.body, id });

    new ProfileUserUsecase()
      .execute(updateProfile)
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public image = catchAsync((req: Request, res: Response) => {
    const id  = userContextManager.getValue('id');
    if (!id) throw CustomError.unAuthorized("Not logged in");

    const updateImage = UpdateImageRequestDto.create({ ...req.body, id });

    new ImageUserUsecase()
      .execute(updateImage)
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public password = catchAsync((req: Request, res: Response) => {
    const id  = userContextManager.getValue('id');
    if (!id) throw CustomError.unAuthorized("Not logged in");

    const updatePassword = UpdatePasswordRequestDto.create({ ...req.body, id });

    new UpdatePasswordUserUsecase()
      .execute(updatePassword)
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });

  public delete = catchAsync((req: Request, res: Response) => {
    const id = +req.params.id;
    if (!id) throw CustomError.badRequest("Missing id");

    new DeleteUserUsecase()
      .execute(id)
      .then((data) => res.status(200).json({ status: true, code: 200, message: 'ok', data }))
      .catch((err) => errorHandler(err, res));
  });
}

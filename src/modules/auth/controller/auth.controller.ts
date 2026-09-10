import { Response, Request } from 'express'
import { catchAsync, CustomError, errorHandler } from '../../../shared';
import { LoginRequestDto, RegisterRequestDto } from '../dto';
import { extractJWT } from '../../../middlewares';
import { LoginUseCase, RefreshUseCase, RegisterUseCase } from '../usecase';

export class AuthController { 

    public login = catchAsync((req:Request, res:Response) =>  {
        const login = LoginRequestDto.create(req.body);

        new LoginUseCase().execute(login)
        .then((data) => res.status(201).json({ status:true, code: 201, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public register = catchAsync((req:Request, res:Response) =>  {
        const register = RegisterRequestDto.create(req.body);

        new RegisterUseCase().execute(register)
        .then((data) => res.status(201).json({ status:true, code: 201, message: 'ok', data }))
        .catch((err) => errorHandler(err, res));
    })

    public refresh = catchAsync((req:Request, res:Response) =>  {
        const token = extractJWT(req);
        if (!token) throw CustomError.unAuthorized('No token provided');

        new RefreshUseCase().execute(token)
        .then((token) => res.json({ status:true, code: 200, message: 'ok', data: { token } }))
        .catch((err) => errorHandler(err, res));
    })
}
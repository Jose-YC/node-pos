import { Request, Response, NextFunction } from 'express';
import { errorHandler } from '../shared';

export const errorMiddleware = (
    error: Error,
    req: Request,
    res: Response,
    next: NextFunction
) => {
    errorHandler(error, res);
};

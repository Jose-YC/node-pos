import { Response } from "express";
import { Prisma } from "../../generated/prisma/client";
import { CustomError } from "./error.custom";
import { HttpStatusCode } from "../../utils";

export const errorHandler = (err: Error, res: Response) => {

    if (err instanceof CustomError) {
        return res.status(err.httpCode).json({
            status: false,
            code: err.httpCode,
            message: err.message,
        });
    }

    if (err instanceof Prisma.PrismaClientKnownRequestError) {
        // Manejar errores de procedimientos almacenados (P2010 con driver adapter)
        if (err.code === 'P2010' && err.meta?.driverAdapterError) {
            const driverError = err.meta.driverAdapterError as any;
            const errorMessage = driverError.message || 'Error';
            return res.status(HttpStatusCode.BAD_REQUEST).json({
                status: false,
                code: HttpStatusCode.BAD_REQUEST,
                message: errorMessage,
            });
        }
    }

        console.error(err);

    res.status(HttpStatusCode.INTERNAL_SERVER_ERROR).json({
        status: false,
        code: HttpStatusCode.INTERNAL_SERVER_ERROR,
        message: 'Error en el servidor'
    });
};
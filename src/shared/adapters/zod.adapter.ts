import { z } from "zod";
import { CustomError } from "../error/error.custom"

export class ZodAdapter {
  static validate<T>(schema: unknown, data: unknown): T {

    if ( !(schema instanceof z.ZodType) ) 
        throw CustomError.badRequest("Esquema proporcionado no válido.")

    const { success, data: formattedData, error } = schema.safeParse(data);

    if (success) {
        return formattedData as T;
    }

    const firsrError = error.issues[0];
    const field = firsrError.path.length > 0 ? firsrError.path.join(".") : null;

    const message = field ? `El campo ${field} ${firsrError.message}.` : `${firsrError.message}.`;

    throw CustomError.badRequest(message);
  }
}
import { z } from 'zod';

import { BasePaginateSchema, DOCUMENTE_TYPE_CODE, DOCUMENTE_TYPE_NAME } from '../../../shared';
import { REGEX_PATTERNS, validatorNumber } from '../../../utils';

export const CreateCustomerSchema = z.object({
    name: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío'),
    doc_code: z.enum(DOCUMENTE_TYPE_CODE, {error: `must be one of: ${DOCUMENTE_TYPE_CODE.join(", ")}`}),
    doc_number: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío'),
    email: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').regex(REGEX_PATTERNS.EMAIL, "debe ser una dirección de correo electrónico válida").optional(),
    phone: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
}).superRefine((data, ctx) => {
    const validator = validatorNumber(DOCUMENTE_TYPE_NAME[data.doc_code], data.doc_number);
    if (validator) {
      ctx.addIssue({
        code:    "custom",
        path:    ["doc_number"],
        message: validator,
      })
    }
});

export const UpdateCustomerSchema = z.object({
    id: z.number({error: "debe ser un numero"}).int({error: "no debe tener decimales"}).positive('debe ser un número entero positivo'),
    name: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
    doc_code: z.enum(DOCUMENTE_TYPE_CODE, {error: `must be one of: ${DOCUMENTE_TYPE_CODE.join(", ")}`}).optional(),
    doc_number: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
    email: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').regex(REGEX_PATTERNS.EMAIL, "debe ser una dirección de correo electrónico válida").optional(),
    phone: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
}).refine( 
  (data) => data.name !== undefined || data.email !== undefined ||
              data.doc_code !== undefined || data.doc_number !== undefined ||
              data.phone !== undefined, 
    'Debe proporcionar al menos un campo para actualizar.'
).superRefine((data, ctx) => {
  if (data.doc_code || data.doc_number) {
    if (!data.doc_code || !data.doc_number) {
      ctx.addIssue({
        code: 'custom',
        path: ['doc_number'],
        message: 'Para cambiar el documento debe enviar tipo y número juntos',
      });
      return;
    }

    const validator = validatorNumber(DOCUMENTE_TYPE_NAME[data.doc_code], data.doc_number);
    if (validator) {
      ctx.addIssue({
        code:    "custom",
        path:    ["doc_number"],
        message: validator,
      })
    }
  }
});

export const PaginateCustomerSchema = BasePaginateSchema;

export type PaginateCustomerInput = z.infer<typeof PaginateCustomerSchema>;
export type CreateCustomerInput = z.infer<typeof CreateCustomerSchema>;
export type UpdateCustomerInput = z.infer<typeof UpdateCustomerSchema>;
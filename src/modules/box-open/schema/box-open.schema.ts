import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

export const CreateBoxOpenSchema = z.object({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    amount: z.number({ error: "must be a number" }).positive("must be greater than 0").multipleOf(0.01, "must have at most 2 decimal places"),
    note: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
});

export const PaginateBoxOpenSchema = BasePaginateSchema;

export type PaginateBoxOpenInput = z.infer<typeof PaginateBoxOpenSchema>;
export type CreateBoxOpenInput = z.infer<typeof CreateBoxOpenSchema>;
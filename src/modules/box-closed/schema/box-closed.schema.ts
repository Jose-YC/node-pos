import { z } from 'zod';

export const CreateBoxClosedSchema = z.object({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    box_open_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    amount_cash: z.number({ error: "must be a number" }).positive("must be greater than 0").multipleOf(0.01, "must have at most 2 decimal places"),
    note: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional()
});

export type CreateBoxClosedInput = z.infer<typeof CreateBoxClosedSchema>;


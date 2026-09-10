import { z } from 'zod';
import { PAYMENT_TYPE } from '../interface/payment.interface';
import { BasePaginateSchema } from '../../../shared';

export const CreatePaymentSchema = z.object({
    name: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
    type: z.enum(PAYMENT_TYPE, {error: `must be one of: ${PAYMENT_TYPE.join(", ")}`}),
});

export const UpdatePaymentSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    name: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
})

export const PaginatePaymentSchema = BasePaginateSchema;

export type PaginatePaymentInput = z.infer<typeof PaginatePaymentSchema>;
export type CreatePaymentInput = z.infer<typeof CreatePaymentSchema>;
export type UpdatePaymentInput = z.infer<typeof UpdatePaymentSchema>;
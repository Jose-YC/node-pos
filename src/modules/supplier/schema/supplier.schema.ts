import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';
import { REGEX_PATTERNS, validatorRUC } from '../../../utils';
import { SUPPLIER_TYPE } from '../interface/supplier.interface';

export const CreateSupplierSchema = z.object({
    name: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
    type: z.enum(SUPPLIER_TYPE, {  error: `must be of type: ${SUPPLIER_TYPE.join(', ')}`}),
    ruc: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').refine(validatorRUC, { error: "must be a valid RUC"}),
    email: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').regex(REGEX_PATTERNS.EMAIL,"must be a valid email address").optional(),
    phone: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').regex(/^\+?\d{7,15}$/,"must be a valid phone").optional(),
});

export const UpdateSupplierSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    name: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').optional(),
    type: z.enum(SUPPLIER_TYPE, {  error: `must be of type: ${SUPPLIER_TYPE.join(', ')}`}).optional(),
    email: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').regex(REGEX_PATTERNS.EMAIL,"must be a valid email address").optional(),
    phone: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').regex(/^\+?\d{7,15}$/,"must be a valid phone").optional(),
}).refine(
    (data) => data.name !== undefined || data.type !== undefined || 
              data.email !== undefined|| data.phone !== undefined,
    'At least one of name, type, ruc, email and phone must be provided'
);

export const PaginateSupplierSchema = BasePaginateSchema;

export type PaginateSupplierInput = z.infer<typeof PaginateSupplierSchema>;
export type CreateSupplierInput = z.infer<typeof CreateSupplierSchema>;
export type UpdateSupplierInput = z.infer<typeof UpdateSupplierSchema>; 
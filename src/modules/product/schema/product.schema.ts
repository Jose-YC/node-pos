import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

export const CreateProductSchema = z.object({
    name: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
    description: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
    image: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
    category_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    min_order_qty: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    min_stock_qty: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    status: z.boolean({error: "must be a boolean"}),
    price_buying: z.number({error: "must be a number"})
                  .refine(
                    (n) => Math.abs(n * 100 - Math.round(n * 100)) < 1e-9,
                    { message: "must have a maximum of 2 decimal places" }
                   ).refine( (n) => n >= 3, { message: "must be at least 3" })
                  .refine( (n) => n >= 3, { message: "must be at least 3" })
                  .refine( (n) => n <= 999999.99, { message: "must be less than 999999.99" }),
    price_selling: z.number({error: "must be a number"})
                  .refine(
                    (n) => Math.abs(n * 100 - Math.round(n * 100)) < 1e-9,
                    { message: "must have a maximum of 2 decimal places" }
                   ).refine( (n) => n >= 3, { message: "must be at least 3" })
                  .refine( (n) => n <= 999999.99, { message: "must be less than 999999.99" }),
});

export const UpdateProductSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    name: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').optional(),
    description: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').optional(),
    category_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional(),
    min_order_qty: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional(),
    min_stock_qty: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional(),
}).refine(
    (data) => data.name !== undefined || data.category_id !== undefined ||
              data.category_id !== undefined || data.min_order_qty !== undefined ||
              data.min_stock_qty !== undefined,
    'At least one of name, type, ruc, email and phone must be provided'
);

export const UpdateImageSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    image: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
})

export const PaginateProductSchema = BasePaginateSchema;
export const PaginateCatalogProductSchema = BasePaginateSchema.extend({
    category: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional()
});

export type PaginateProductInput = z.infer<typeof PaginateProductSchema>;
export type PaginateCatalogProductInput = z.infer<typeof PaginateCatalogProductSchema>;
export type UpdateImageInput = z.infer<typeof UpdateImageSchema>;
export type CreateProductInput = z.infer<typeof CreateProductSchema>;
export type UpdateProductInput = z.infer<typeof UpdateProductSchema>; 
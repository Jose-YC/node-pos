import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

const StockAdjustmentItemSchema = z.object({
    product_id: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be a positive integer"),
    qty: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be greater than 0")
});

const ArrayItemsStockAdjustmentSchema = z.array(StockAdjustmentItemSchema).min(1, "at least one item is required").refine((items) => new Set(items.map((item) => item.product_id)).size === items.length, "product cannot be duplicated");

export const CreateStockAdjustmentSchema = z.object({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    reason_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    notes: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
    items: ArrayItemsStockAdjustmentSchema
});

export const UpdateStockAdjustmentSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    reason_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional(),
    notes: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
    items: ArrayItemsStockAdjustmentSchema.optional()
})
.refine(
     (data) =>  data.reason_id !== undefined || data.items !== undefined || data.notes !== undefined,
     'At least one of reason or products must be provided'
);

export const PaginateStockAdjustmentSchema = BasePaginateSchema;

export type PaginateStockAdjustmentInput = z.infer<typeof PaginateStockAdjustmentSchema>;
export type CreateStockAdjustmentInput = z.infer<typeof CreateStockAdjustmentSchema>;
export type UpdateStockAdjustmentInput = z.infer<typeof UpdateStockAdjustmentSchema>;

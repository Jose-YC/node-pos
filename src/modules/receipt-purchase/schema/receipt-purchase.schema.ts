import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

const ReceiptPurchaseItemSchema = z.object({
    product_id: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be a positive integer"),
    qty_received: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be greater than 0"),
    qty_reject: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).nonnegative("must be greater than or equal to 0"),
})
.refine(
    (item) => item.qty_reject < item.qty_received,
    "reject cannot be greater than received"
);

const ArrayItemsReceiptPurchaseSchema = z.array(ReceiptPurchaseItemSchema).min(1, "at least one item is required").refine((items) => new Set(items.map((item) => item.product_id)).size === items.length, "product cannot be duplicated")

export const CreateReceiptPurchaseSchema = z.object({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    purchase_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    items: ArrayItemsReceiptPurchaseSchema
});

export const UpdateReceiptPurchaseSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    items: ArrayItemsReceiptPurchaseSchema
});

export const PaginateReceiptPurchaseSchema = BasePaginateSchema;

export type PaginateReceiptPurchaseInput = z.infer<typeof PaginateReceiptPurchaseSchema>;
export type CreateReceiptPurchaseInput = z.infer<typeof CreateReceiptPurchaseSchema>;
export type UpdateReceiptPurchaseInput = z.infer<typeof UpdateReceiptPurchaseSchema>;
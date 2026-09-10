import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

const OrderPurchaseItemSchema = z.object({
    product_id: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be a positive integer"),
    qty: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be greater than 0"),
    price: z.number({ error: "must be a number" }).positive("must be greater than 0").multipleOf(0.01, "must have at most 2 decimal places"),
});

const ArrayItemsOrderPurchaseSchema = z.array(OrderPurchaseItemSchema).min(1, "at least one item is required").refine((items) => new Set(items.map((item) => item.product_id)).size === items.length, "product cannot be duplicated");

export const CreateOrderPurchaseSchema = z.object({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    supplier_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    address: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty'),
    delivery_date: z.coerce.date({error: "must be a date"}),
    items: ArrayItemsOrderPurchaseSchema
});

export const UpdateOrderPurchaseSchema = z.object({
    id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    supplier_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional(),
    address: z.string({error: "must be a string"}).trim().min(1, 'cannot be empty').optional(),
    delivery_date: z.coerce.date({error: "must be a date"}).optional(),
    items: ArrayItemsOrderPurchaseSchema.optional()
})
.refine(
     (data) =>  data.supplier_id !== undefined || data.address !== undefined 
                || data.delivery_date !== undefined || data.items !== undefined,
     'At least one of supplier, address, delivery date or products must be provided'
);

export const PaginateOrderPurchaseSchema = BasePaginateSchema;

export type PaginateOrderPurchaseInput = z.infer<typeof PaginateOrderPurchaseSchema>;
export type CreateOrderPurchaseInput = z.infer<typeof CreateOrderPurchaseSchema>;
export type UpdateOrderPurchaseInput = z.infer<typeof UpdateOrderPurchaseSchema>;
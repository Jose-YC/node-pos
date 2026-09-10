import { z } from 'zod';

import { BasePaginateSchema, DOCUMENTE_TYPE_CODE, DOCUMENTE_TYPE_NAME } from '../../../shared';
import { validatorNumber } from '../../../utils';

const ItemsSchema = z.object({
    product_id: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be a positive integer"),
    qty: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be greater than 0")
});

const CustomerSchema = z.object({
    customer_id: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be a positive integer").optional(),
    customer_type: z.enum(DOCUMENTE_TYPE_CODE, {error: `must be one of: ${DOCUMENTE_TYPE_CODE.join(", ")}`}).optional(),
    customer_number: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
    customer_name: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional(),
}).superRefine((data, ctx) => {
    if (data.customer_id) {
        if (data.customer_type || data.customer_number || data.customer_name) {
            ctx.addIssue({
                code: 'custom',
                path: ['customer_id'],
                message: 'Si se ingresa un cliente registrado, no se deben enviar los campos de identificacion',
            });
        }
        return; 
    };

    if (data.customer_type || data.customer_number || data.customer_name) {
        if (!data.customer_type || !data.customer_number || !data.customer_name) {
            ctx.addIssue({
                code: 'custom',
                path: ['customer_number'],
                message: 'Se debe ingresar el tipo de documento, numero del documento y el nombre del cliente',
            });
            return;
        };
        
        const validator = validatorNumber(DOCUMENTE_TYPE_NAME[data.customer_type], data.customer_number);
        if (validator) {
          ctx.addIssue({
            code:    "custom",
            path:    ["customer_number"],
            message: validator,
          })
        };
    };
});

const PaymentItemSchema = z.object({
    payment_id: z.number({ error: "must be a number" }).int({ error: "must not have decimal places" }).positive("must be a positive integer"),
    amount: z.number({ error: "must be a number" }).positive("must be greater than 0").multipleOf(0.01, "must have at most 2 decimal places")
});

const ArrayItemsSchema = z.array(ItemsSchema).min(1, "at least one item is required").refine((items) => new Set(items.map((item) => item.product_id)).size === items.length, "product cannot be duplicated");

const ArrayItemsPaymentSchema = z.array(PaymentItemSchema).min(1, "at least one item is required").refine((items) => new Set(items.map((item) => item.payment_id)).size === items.length, "payment cannot be duplicated");

export const CreateSaleSchema = z.object({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    box_open_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    customer: CustomerSchema.optional(),
    items: ArrayItemsSchema,
    payment: ArrayItemsPaymentSchema
});

export const CreateCreditNoteSchema = z.object({
    saleid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    box_open_id: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer'),
    items: ArrayItemsSchema,
    payment: ArrayItemsPaymentSchema,
    notes: z.string({error: "debe ser una cadena de texto"}).trim().min(1, 'no puede estar vacío').optional()
});

export const PaginateSaleSchema = BasePaginateSchema.extend({
    userid: z.number({error: "must be a number"}).int({error: "must not have decimal places"}).positive('must be a positive integer').optional()
});

export type PaginateSaleInput = z.infer<typeof PaginateSaleSchema>;
export type CreateSaleInput = z.infer<typeof CreateSaleSchema>;
export type CreateCreditNoteInput = z.infer<typeof CreateCreditNoteSchema>;
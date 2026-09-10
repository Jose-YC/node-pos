import { z } from 'zod';
import { numberField, stringField, BasePaginateSchema } from '../../../shared';

export const CreateCategorySchema = z.object({
    name: stringField().toLowerCase(),
    description: stringField().optional(),
});

export const UpdateCategorySchema = z.object({
    id: numberField().positive('must be a positive integer'),
    name: stringField().optional(),
    description: stringField().optional(),
}).refine(
    (data) => data.name !== undefined || data.description !== undefined,
    'At least one of name or description must be provided'
);

export const PaginateCategorySchema = BasePaginateSchema;

export type PaginateCategoryInput = z.infer<typeof PaginateCategorySchema>;
export type CreateCategoryInput = z.infer<typeof CreateCategorySchema>;
export type UpdateCategoryInput = z.infer<typeof UpdateCategorySchema>;
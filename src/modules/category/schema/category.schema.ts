import { z } from 'zod';
import { BasePaginateSchema, BaseOptionsSchema } from '../../../shared';

export const CreateCategorySchema = z.object({
    name: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase(),
    description: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),
});

export const UpdateCategorySchema = z.object({
    id:  z.number('debe ser un numero').int('no debe tener decimales').positive('debe ser un número entero positivo'),
    name: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),
    description: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),
}).refine(
    (data) => data.name !== undefined || data.description !== undefined,
    'At least one of name or description must be provided'
);

export const PaginateCategorySchema = BasePaginateSchema;
export const OptionsCategorySchema = BaseOptionsSchema

export type PaginateCategoryInput = z.infer<typeof PaginateCategorySchema>;
export type OptionsCategoryInput = z.infer<typeof OptionsCategorySchema>;
export type CreateCategoryInput = z.infer<typeof CreateCategorySchema>;
export type UpdateCategoryInput = z.infer<typeof UpdateCategorySchema>;
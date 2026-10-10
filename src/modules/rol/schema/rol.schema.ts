import { z } from 'zod';
import { arrayNumberField, numberField, stringField, BasePaginateSchema } from '../../../shared';

const ArrayPermission = z.array(z.number('debe ser un numero').int('no debe tener decimales').positive('debe ser un entero positivo')).min(2, 'must have at least 2 permissions').refine((items) => new Set(items).size === items.length,'must not contain duplicates')

export const CreateRoleSchema = z.object({
    name: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase(),
    description: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),
    permissions: ArrayPermission
});

export const UpdateRoleSchema = z.object({
    id: z.number('debe ser un numero').int('no debe tener decimales').positive('debe ser un número entero positivo')  ,
    name: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase().optional(),
    description: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),
    permissions: ArrayPermission.optional()
.optional(),
}).refine(
    (data) => data.name !== undefined || data.description !== undefined || data.permissions !== undefined,
    'At least one of name, description or permissions must be provided'
);

export const PaginateRolesSchema = BasePaginateSchema;

export type PaginateRolesInput = z.infer<typeof PaginateRolesSchema>;
export type CreateRoleInput = z.infer<typeof CreateRoleSchema>;
export type UpdateRoleInput = z.infer<typeof UpdateRoleSchema>;
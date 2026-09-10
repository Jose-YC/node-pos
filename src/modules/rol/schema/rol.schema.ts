import { z } from 'zod';
import { arrayNumberField, numberField, stringField, BasePaginateSchema } from '../../../shared';

export const CreateRoleSchema = z.object({
    name: stringField().toLowerCase(),
    description: stringField(),
    permissions: arrayNumberField().min(2, `must have at least 2 permissions`),
});

export const UpdateRoleSchema = z.object({
    id: numberField().positive('must be a positive integer'),
    name: stringField().toLowerCase().optional(),
    description: stringField().optional(),
    permissions: arrayNumberField().min(2, `must have at least 2 permissions`).optional(),
}).refine(
    (data) => data.name !== undefined || data.description !== undefined || data.permissions !== undefined,
    'At least one of name, description or permissions must be provided'
);

export const PaginateRolesSchema = BasePaginateSchema;

export type PaginateRolesInput = z.infer<typeof PaginateRolesSchema>;
export type CreateRoleInput = z.infer<typeof CreateRoleSchema>;
export type UpdateRoleInput = z.infer<typeof UpdateRoleSchema>;
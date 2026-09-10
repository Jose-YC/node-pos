import { z } from 'zod';
import { numberField, stringField, BasePaginateSchema } from '../../../shared';

export const CreatePermissionSchema = z.object({
    name: stringField().toLowerCase(),
    module: stringField(),
});

export const UpdatePermissionSchema = z.object({
    id: numberField().positive('must be a positive integer'),
    name: stringField().optional(),
    module: stringField().optional(),
}).refine(
    (data) => data.name !== undefined || data.module !== undefined,
    'At least one of name or module must be provided'
);

export const PaginatePermissionSchema = BasePaginateSchema;

export type PaginatePermissionInput = z.infer<typeof PaginatePermissionSchema>;
export type CreatePermissionInput = z.infer<typeof CreatePermissionSchema>;
export type UpdatePermissionInput = z.infer<typeof UpdatePermissionSchema>;
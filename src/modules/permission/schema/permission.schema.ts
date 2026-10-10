import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

export const CreatePermissionSchema = z.object({
    name: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase(),
    module: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toUpperCase(),
    description: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),
});

export const UpdatePermissionSchema = z.object({
    id: z.number('debe ser un numero').int('no debe tener decimales').positive('debe ser un número entero positivo'),
    name: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase().optional(),
    module: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toUpperCase().optional(),
    description: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').optional(),

}).refine(
    (data) => data.name !== undefined || data.module !== undefined || data.description !== undefined,
    'At least one of name, module, or description must be provided'
);

export const PaginatePermissionSchema = BasePaginateSchema;

export type PaginatePermissionInput = z.infer<typeof PaginatePermissionSchema>;
export type CreatePermissionInput = z.infer<typeof CreatePermissionSchema>;
export type UpdatePermissionInput = z.infer<typeof UpdatePermissionSchema>;
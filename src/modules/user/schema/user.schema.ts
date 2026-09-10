import { z } from 'zod';
import { REGEX_PATTERNS } from '../../../utils';
import { arrayNumberField, BasePaginateSchema, numberField, stringField } from '../../../shared';

export const CreateUserSchema = z.object({
    email: stringField().regex(REGEX_PATTERNS.EMAIL, "must be a valid email address"),
    name: stringField(),
    password: stringField().regex(REGEX_PATTERNS.PASSWORD_STRONG, "must be at least 6 characters long and include uppercase letters, lowercase letters, numbers, and special characters"),
    rol: arrayNumberField().min(1, `must have at least 1 role`),
});

export const UpdateUserSchema = z.object({
    id: numberField().positive('must be a positive integer'),
    email: stringField().regex(REGEX_PATTERNS.EMAIL, "must be a valid email address").optional(),
    name: stringField().optional(),
    password: stringField().regex(REGEX_PATTERNS.PASSWORD_STRONG, "must be at least 6 characters long and include uppercase letters, lowercase letters, numbers, and special characters").optional(),
    rol: arrayNumberField().min(1, `must have at least 1 role`).optional(),
}).refine(
    (data) => data.name !== undefined || data.email !== undefined || data.password !== undefined || data.rol !== undefined,
    'At least one of name, email, password or roles must be provided'
);

export const UpdatePasswordSchema = z.object({
    id: numberField().positive('must be a positive integer'),
    currentPassword: stringField(),
    newPassword: stringField().regex(REGEX_PATTERNS.PASSWORD_STRONG, "must be at least 6 characters long and include uppercase letters, lowercase letters, numbers, and special characters"),
});

export const UpdateProfileSchema = z.object({
    id: numberField().positive('must be a positive integer'),
    name: stringField().optional(),
}).refine(
    (data) => data.name !== undefined ,
    'At least one of name must be provided'
);

export const UpdateImageSchema = z.object({
    id: numberField().positive('must be a positive integer'),
    image: stringField(),
})

export const PaginateUserSchema = BasePaginateSchema.extend({
    rol: numberField().positive('must be a positive integer').optional(),
});

export type UpdateImageInput = z.infer<typeof UpdateImageSchema>;
export type PaginateUserInput = z.infer<typeof PaginateUserSchema>;
export type CreateUserInput = z.infer<typeof CreateUserSchema>;
export type UpdateUserInput = z.infer<typeof UpdateUserSchema>;
export type UpdatePasswordInput = z.infer<typeof UpdatePasswordSchema>;
export type UpdateProfileInput = z.infer<typeof UpdateProfileSchema>;
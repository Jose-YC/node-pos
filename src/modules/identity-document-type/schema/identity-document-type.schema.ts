import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

export const PaginateIdentityDocumentTypeSchema = BasePaginateSchema;
export type PaginateIdentityDocumentTypeInput = z.infer<typeof PaginateIdentityDocumentTypeSchema>;

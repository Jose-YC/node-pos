import { z } from 'zod';
import { BasePaginateSchema } from '../../../shared';

export const PaginateTypeDocumentSaleSchema = BasePaginateSchema;
export type PaginateTypeDocumentSaleInput = z.infer<typeof PaginateTypeDocumentSaleSchema>;

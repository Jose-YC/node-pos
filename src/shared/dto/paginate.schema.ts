import z from "zod";
import { numberField, stringField } from "../schema/fields";

export const BasePaginateSchema = z.object({
  page: numberField().min(1, 'must be a positive integer'),
  lim: numberField().min(1, 'must be a positive integer').max(10, 'must be less than or equal to 10'),
  search: stringField().optional(),
});



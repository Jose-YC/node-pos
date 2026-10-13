import z from "zod";

export const BasePaginateSchema = z.object({
  page: z.number('debe ser un numero').int('no debe tener decimales').positive('debe ser un número entero positivo'),
  limit: z.number('debe ser un numero').int('no debe tener decimales').positive('debe ser un número entero positivo').max(10, 'debe ser menor o igual a 10'),
  search: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase().optional(),
});

export const BaseOptionsSchema = z.object({
  search: z.string('debe ser una cadena de texto').trim().min(1, 'no puede estar vacío').toLowerCase().optional(),
});


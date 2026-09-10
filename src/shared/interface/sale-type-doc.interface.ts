
export const SALE_DOCUMENTE_TYPE_CODE = ['01', '03', '07'] as const
export type SaleTipeDocument = typeof SALE_DOCUMENTE_TYPE_CODE[number];

export const SALE_DOCUMENTE_TYPE_NAME: Record<SaleTipeDocument, string> = {
  "01": "FACTURA",
  "03": "BOLETA",
  "07": "NOTA_CREDITO",
};
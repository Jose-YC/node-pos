
export const DOCUMENTE_TYPE_CODE = ['06','01', '04', '07'] as const
export type TipeDocument = typeof DOCUMENTE_TYPE_CODE[number];

export const DOCUMENTE_TYPE_NAME: Record<TipeDocument, string> = {
  "01": "DNI",
  "04": "CE",
  "06": "RUC",
  "07": "PAS",
};
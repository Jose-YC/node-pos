export interface PaymentRaw {
  id: number,
  name: string,
  type: string,
  status: boolean,
};

export const PAYMENT_TYPE = ['cash', 'card', 'yape', 'plin', 'example'] as const;
export type PaymentType = typeof PAYMENT_TYPE[number];
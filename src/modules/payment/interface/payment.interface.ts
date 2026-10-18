export interface PaymentRaw {
  id: number,
  name: string,
  type: PaymentType,
  status: boolean,
};

export const PAYMENT_TYPE = ['cash', 'bank', 'digital_wallet'] as const;
export type PaymentType = typeof PAYMENT_TYPE[number];
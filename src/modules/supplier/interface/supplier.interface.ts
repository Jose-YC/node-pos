export interface SupplierRaw {
  id: number,
  name:string,
  type:string,
  ruc:string,
  email?:string,
  phone?:string,
}

export const SUPPLIER_TYPE = ['natural', 'juridico'] as const;  
export type SuplierType = typeof SUPPLIER_TYPE[number];
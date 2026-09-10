export interface ReceiptPurchaseRaw {
    id: number;
    serie: string;
    status: string;
    supplier_ruc: string;
    supplier_name:string
    date_receipt:Date
    total:number
}

type NumericValue = number | { toNumber(): number } | any;

export interface DetailReceiptPurchaseRaw {
  product_id: number;
  product_name: string;
  qty_received: number;
  qty_reject: number;
  qty_accepted: number;
  price: NumericValue;
  subtotal: NumericValue;
  detail_order_purchase: {
    qty_received: number;
  };
}

export interface ReceiptPurchaseByIdRaw {
  id: number;
  serie: string;
  status: string;
  supplier_id: number;
  supplier_ruc: string;
  supplier_name: string;
  date_receipt: Date;
  note: string | null;
  total: NumericValue;
  detailReceiptPurchases: DetailReceiptPurchaseRaw[];
}
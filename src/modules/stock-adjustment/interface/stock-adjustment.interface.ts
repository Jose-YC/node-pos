export interface StockAdjustmentRaw {
    id: number;
    serie: string;
    stock_adjustment_date: Date;
    reason_name: string;
    direction: string;
    total_qty:number;
    total_value :number;
    status: string;
}

type NumericValue = number | { toNumber(): number } | any;

export interface DetailStockAdjustmentRaw {
  product_id: number;
  product_name: string;
  qty: number;
  valuation_rate: NumericValue;
  subtotal: NumericValue;
}

export interface StockAdjustmentByIdRaw {
  id: number;
  serie: string;
  status: string;
  stock_adjustment_date: Date;
  reason_id: number;
  reason_name: string;
  direction: string;
  notes: string | null;
  total_qty: number;
  total_value: NumericValue;
  detailStockAdjustments: DetailStockAdjustmentRaw[];
}

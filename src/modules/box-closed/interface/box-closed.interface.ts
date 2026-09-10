type NumericValue = number | { toNumber(): number } | any;

export interface DetailBoxClosedRaw {
  mode_payment: number;
  mode_payment_name: string;
  opening_amount: NumericValue;
  expected_amount: NumericValue;
  closing_amount: NumericValue;
  difference_amount: NumericValue;
}

export interface BoxClosedByIdRaw {
  id: number;
  serie: string;
  status: string;
  start_date: Date;
  end_date: Date;
  notes: string | null;
  detailBoxesClose: DetailBoxClosedRaw[];
}
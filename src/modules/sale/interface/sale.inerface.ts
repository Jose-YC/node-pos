import { SaleTipeDocument } from "../../../shared";

export interface SaleRaw {
    id:          	        number,
    serie:        	        string,
    type_code:              SaleTipeDocument,
    sale_date: 	            Date,
    customer_name: 	        string,
    customer_doc_code: 	    string,
    customer_doc_number:    string,
    igv_rate:   		    number,       
    taxable_amount:   	    number,       
    igv_total:   		    number,       
    total:   		        number,       
    paid_amount:   		    number,       
    change_amount:          number,   
    is_return:              boolean,
    return_against_id?:     number 
}

type NumericValue = number | { toNumber(): number } | any;

export interface DetailSaleRaw {
  product_id: number;
  product_name: string;
  qty: number;
  price: NumericValue;
  subtotal: NumericValue;
}

export interface SalePaymentRaw {
  payment_id: number;
  payment_name: string;
  amount: NumericValue;
}

export interface SaleByIdRaw {
  id: number;
  serie: string;
  type_code: SaleTipeDocument;
  customer_name: string;
  customer_doc_code: string;
  customer_doc_number: string;
  igv_rate: NumericValue;
  taxable_amount: NumericValue;
  igv_total: NumericValue;
  total: NumericValue;
  paid_amount: NumericValue;
  change_amount: NumericValue;
  is_return: boolean;
  return_against_id: number | null;
  sale_date: Date;
  detailSales: DetailSaleRaw[];
  salePayments: SalePaymentRaw[];
}
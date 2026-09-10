import { SALE_DOCUMENTE_TYPE_NAME } from "../../../shared";
import { SaleListItemDto, SaleResponseDto } from "../dto";
import { SaleByIdRaw, SaleRaw } from "../interface/sale.inerface";

export class SaleMapper {

  static toListItemDto(sale: SaleRaw): SaleListItemDto {
    return {
      id: sale.id,
      serie: sale.serie,
      doc_type: SALE_DOCUMENTE_TYPE_NAME[sale.type_code],
      sale_date: sale.sale_date,
      customer_name: sale.customer_name,
      customer_doc_code: sale.customer_doc_code,
      customer_doc_number: sale.customer_doc_number,
      igv_rate: sale.igv_rate,
      taxable_amount: sale.taxable_amount,
      igv_total: sale.igv_total,
      total: sale.total,
      paid_amount: sale.paid_amount,
      change_amount: sale.change_amount,
      is_return: sale.is_return,
      return_against_id: sale.return_against_id
    };
  }

  static toListItemDtoArray(sales: SaleRaw[]): SaleListItemDto[] {
    return sales.map(sale => this.toListItemDto(sale));
  }

  static toResponseDto(sale: SaleByIdRaw): SaleResponseDto {
    return {
      id: sale.id,
      serie: sale.serie,
      type: SALE_DOCUMENTE_TYPE_NAME[sale.type_code],
      sale_date: sale.sale_date,
      customer_name: sale.customer_name,
      customer_doc_code: sale.customer_doc_code,
      customer_doc_number: sale.customer_doc_number,
      igv_rate: sale.igv_rate,
      taxable_amount: sale.taxable_amount,
      igv_total: sale.igv_total,
      total: sale.total,
      paid_amount: sale.paid_amount,
      change_amount: sale.change_amount,
      is_return: sale.is_return,
      return_against_id: sale.return_against_id || undefined,
      items: sale.detailSales.map(detail => ({
        product_id: detail.product_id,
        product_name: detail.product_name,
        qty: detail.qty,
        price: detail.price,
        subtotal: detail.subtotal
      })),
      payments: sale.salePayments.map(payment => ({
        payment_id: payment.payment_id,
        payment_name: payment.payment_name,
        amount: payment.amount
      }))
    };
  }
}
import { ReceiptPurchaseListItemDto, ReceiptPurchaseResponseDto } from "../dto";
import { ReceiptPurchaseRaw, ReceiptPurchaseByIdRaw } from "../interface/receipt-purchase.interface";

export class ReceiptPurchaseMapper {

  static toListItemDto(receipt: ReceiptPurchaseRaw): ReceiptPurchaseListItemDto {
    return {
      id: receipt.id,
      serie: receipt.serie,
      status: receipt.status,
      supplier_ruc: receipt.supplier_ruc,
      supplier_name: receipt.supplier_name,
      date_receipt: receipt.date_receipt,
      total: receipt.total
    };
  }

  static toListItemDtoArray(roles: ReceiptPurchaseRaw[]): ReceiptPurchaseListItemDto[] {
    return roles.map(role => this.toListItemDto(role));
  }

  static toResponseDto(receipt: ReceiptPurchaseByIdRaw): ReceiptPurchaseResponseDto {
    return {
      id: receipt.id,
      serie: receipt.serie,
      status: receipt.status,
      supplier_id: receipt.supplier_id,
      supplier_ruc: receipt.supplier_ruc,
      supplier_name: receipt.supplier_name,
      date_receipt: receipt.date_receipt,
      total: receipt.total,
      items: receipt.detailReceiptPurchases.map(detail => ({
        product_id: detail.product_id,
        product_name: detail.product_name,
        qty_order: detail.detail_order_purchase.qty_received,
        qty_received: detail.qty_received,
        qty_reject: detail.qty_reject,
        qty_accepted: detail.qty_accepted,
        price: detail.price,
        subtotal: detail.subtotal
      })),
      note: receipt.note || undefined
    };
  }
}
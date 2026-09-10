import { OrderPurchaseListItemDto, OrderPurchaseResponseDto } from "../dto";
import { OrderPurchaseRaw, OrderPurchaseByIdRaw } from "../interface/order-purchase.interface";

export class OrderPurchaseMapper {

  static toListItemDto(order: OrderPurchaseRaw): OrderPurchaseListItemDto {
    return {
      id: order.id,
      serie: order.serie,
      status: order.status,
      supplier_ruc: order.supplier_ruc,
      supplier_name: order.supplier_name,
      delivery_date: order.delivery_date,
      total: order.total
    };
  }

  static toListItemDtoArray(roles: OrderPurchaseRaw[]): OrderPurchaseListItemDto[] {
    return roles.map(role => this.toListItemDto(role));
  }

  static toResponseDto(order: OrderPurchaseByIdRaw): OrderPurchaseResponseDto {
    return {
      id: order.id,
      serie: order.serie,
      status: order.status,
      supplier_id: order.supplier_id,
      supplier_ruc: order.supplier_ruc,
      supplier_name: order.supplier_name,
      address_purchase: order.address_purchase,
      delivery_date: order.delivery_date,
      total: order.total,
      items: order.detailOrderPurchases.map(detail => ({
        product_id: detail.product_id,
        product_name: detail.product_name,
        qty_received: detail.qty_received,
        qty: detail.qty,
        price: detail.price,
        subtotal: detail.subtotal
      }))
    };
  }
}
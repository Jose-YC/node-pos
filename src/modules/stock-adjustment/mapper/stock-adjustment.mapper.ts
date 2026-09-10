import { StockAdjustmentListItemDto, StockAdjustmentResponseDto } from "../dto";
import { StockAdjustmentByIdRaw, StockAdjustmentRaw } from "../interface/stock-adjustment.interface";

export class StockAdjustmentMapper {

  static toListItemDto(StockAdjustment: StockAdjustmentRaw): StockAdjustmentListItemDto {
    return {
      id: StockAdjustment.id,
      serie: StockAdjustment.serie,
      adjustment_date: StockAdjustment.stock_adjustment_date,
      reason: StockAdjustment.reason_name,
      direction: StockAdjustment.direction,
      total_qty: StockAdjustment.total_qty,
      total_value: StockAdjustment.total_value,
      status: StockAdjustment.status,
    };
  }

  static toListItemDtoArray(StockAdjustments: StockAdjustmentRaw[]): StockAdjustmentListItemDto[] {
    return StockAdjustments.map(StockAdjustment => this.toListItemDto(StockAdjustment));
  }

  static toResponseDto(StockAdjustment: StockAdjustmentByIdRaw): StockAdjustmentResponseDto {
    return {
      id: StockAdjustment.id,
      serie: StockAdjustment.serie,
      adjustment_date: StockAdjustment.stock_adjustment_date,
      reason_id: StockAdjustment.reason_id,
      reason_name: StockAdjustment.reason_name,
      direction: StockAdjustment.direction,
      total_qty: StockAdjustment.total_qty,
      total_value: StockAdjustment.total_value,
      status: StockAdjustment.status,
      items: StockAdjustment.detailStockAdjustments.map(detail => ({
        product_id: detail.product_id,
        product_name: detail.product_name,
        qty: detail.qty,
        valuation_rate: detail.valuation_rate,
        subtotal: detail.subtotal
      }))
    };
  }
}
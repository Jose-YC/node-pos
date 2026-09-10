import { ClosedBoxDResponseDto } from "../dto";
import { BoxClosedByIdRaw } from "../interface/box-closed.interface";

export class BoxClosedMapper {

  static toResponseDto(box: BoxClosedByIdRaw): ClosedBoxDResponseDto {
    return {
      id: box.id,
      serie: box.serie,
      status: box.status,
      start: box.start_date,
      end: box.end_date,
      notes: box.notes || undefined,
      payments: box.detailBoxesClose.map(detail => ({
        mode_payment: detail.mode_payment,
        mode_payment_name: detail.mode_payment_name,
        opening_amount: Number(detail.opening_amount),
        expected_amount: Number(detail.expected_amount),
        closing_amount: Number(detail.closing_amount),
        difference_amount: Number(detail.difference_amount),
      })),
    };
  }
}
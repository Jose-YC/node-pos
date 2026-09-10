import { BoxOpenListItemDto } from "../dto";
import { BoxOpenRaw } from "../interface/box-open.interface";

export class BoxOpenMapper {

  static toListItemDto(box: BoxOpenRaw): BoxOpenListItemDto {
    return {
      id: box.id,
      serie: box.serie,
      status: box.status,
      start: box.start_date,
      end: box.end_date,
    };
  }

  static toListItemDtoArray(boxs: BoxOpenRaw[]): BoxOpenListItemDto[] {
    return boxs.map(box => this.toListItemDto(box));
  }
}
import { SupplierResponseDto } from "../dto";
import { SupplierRaw, SuplierType } from "../interface/supplier.interface";

export class SupplierMapper {
    static toResponseDto(raw: SupplierRaw): SupplierResponseDto {
        return new SupplierResponseDto(
            raw.id,
            raw.name,
            raw.type as SuplierType,
            raw.ruc,
            raw.email,
            raw.phone,
        );
    }

    static toResponseDtoList(raws: SupplierRaw[]): SupplierResponseDto[] {
        return raws.map(raw => this.toResponseDto(raw));
    }
}
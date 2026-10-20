import { TypeDocumentSaleOptionsRaw, TypeDocumentSaleRaw } from "../interface/type-document-sale.interface";
import { TypeDocumentSaleResponseDto } from "../dto";
import { OptionsDto } from "../../../shared";

export class TypeDocumentSaleMapper {
    static toResponseDto(typeDocumentSale: TypeDocumentSaleRaw): TypeDocumentSaleResponseDto {
      return {
        id: typeDocumentSale.id,
        name: typeDocumentSale.name,
        code: typeDocumentSale.code,
        short_name: typeDocumentSale.short_name,
        status: typeDocumentSale.status,
      };
    }

    static toResponseOptionsDto(typeDocumentSales: TypeDocumentSaleOptionsRaw[]): OptionsDto[] {
        return typeDocumentSales.map(typeDocumentSale => ({
            id: typeDocumentSale.id,
            label: typeDocumentSale.name,
        }));
    }

    static toResponseDtoList(typeDocumentSales: TypeDocumentSaleRaw[]): TypeDocumentSaleResponseDto[] {
        return typeDocumentSales.map(typeDocumentSale => this.toResponseDto(typeDocumentSale));
    }
}
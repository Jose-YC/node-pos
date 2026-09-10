import { RawProduct, RawCatalogProduct, RawProductById } from "../interface/product.interface";
import { ProductResponseDto, CatalogProductResponseDto, ProductByIdResponseDto } from "../dto";

export class ProductMapper {

    static toItemDto(product: RawProductById): ProductByIdResponseDto {
        return {
            id: product.id,
            sku: product.sku,
            name: product.name,
            description: product.description,
            image: product.image,
            category:{
                id: product.category_id,
                name: product.category_name
            },
            min_order_qty: product.min_order_qty,
            min_stock: product.min_stock,
            status: product.status,
            stock: product.stock,
            price_buying: product.price_buying,
            price_selling: product.price_selling,
        }
    }

    static toListItemDto(product: RawProduct): ProductResponseDto {
        return {
            id: product.id,
            sku: product.sku,
            name: product.name,
            description: product.description,
            image: product.image,
            category_name: product.category_name,
            min_order_qty: product.min_order_qty,
            min_stock: product.min_stock,
            status: product.status
        }
    }

    static toListItemDtoList(products: RawProduct[]): ProductResponseDto[] {
        return products.map((product) => this.toListItemDto(product));
    }

    static toListCatalogItemDto(product: RawCatalogProduct): CatalogProductResponseDto {
        return {
            id: product.id,
            name: product.name,
            image: product.image,
            category_name: product.category_name,
            stock: product.stock,
            price: product.price_selling,
        }
    }

    static toListCatalogItemDtoList(products: RawCatalogProduct[]): CatalogProductResponseDto[] {
        return products.map((product) => this.toListCatalogItemDto(product));
    }
}
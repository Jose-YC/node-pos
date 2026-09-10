import { ProductResponseDto, CatalogProductResponseDto, ProductByIdResponseDto, CreateProductRequestDto, UpdateProductRequestDto, ProductPaginateDto, CatalogProductPaginateDto} from "../dto";
import { RawProduct, RawCatalogProduct, RawProductById } from "../interface/product.interface";
import { List, CustomError } from "../../../shared";
import { ProductMapper } from "../mapper/product.mapper";
import { prisma } from "../../../config";
import { UpdateProductImageRequestDto } from "../dto/request/product.image";

export class ProductDatasource {
  async create(createProduct: CreateProductRequestDto): Promise<boolean> {
    await prisma.$executeRaw`
        CALL sp_CreateProduct(
            p_name := ${createProduct.name}::TEXT,
            p_description := ${createProduct.description}::TEXT,
            p_image := ${createProduct.image}::TEXT,
            p_category_id := ${createProduct.category_id}::INTEGER,
            p_min_order_qty := ${createProduct.min_order_qty}::INTEGER,
            p_min_stock := ${createProduct.min_stock_qty}::INTEGER,
            p_status := ${createProduct.status}::BOOLEAN,
            p_price_buying := ${createProduct.price_buying}::NUMERIC(8,2),
            p_price_selling := ${createProduct.price_selling}::NUMERIC(8,2)
        );
    `;

    return true;
  }

  async get(paginate: ProductPaginateDto): Promise<List<ProductResponseDto>> {
    const [count, products] = await Promise.all([
      prisma.$queryRaw<{ fc_countlistproducts: number }[]>`
          SELECT * FROM fc_CountListProducts(
          p_search := ${paginate.search}::TEXT
      );`,

      prisma.$queryRaw<RawProduct[]>`SELECT * FROM fc_ListProducts(
          p_page := ${paginate.page}::INTEGER,
          p_limit := ${paginate.lim}::INTEGER,
          p_search := ${paginate.search}::TEXT
      );`
    ]);

    return { 
      total: count[0].fc_countlistproducts, 
      items: ProductMapper.toListItemDtoList(products)
    };
  }

  async getCatalog(paginate: CatalogProductPaginateDto): Promise<List<CatalogProductResponseDto>> {
    const [count, products] = await Promise.all([
      prisma.$queryRaw<{ fc_countlistcatalogproducts: number }[]>`
          SELECT * FROM fc_CountListCatalogProducts(
          p_search := ${paginate.search}::TEXT,
          p_category := ${paginate.category}::INTEGER
      );`,

      prisma.$queryRaw<RawCatalogProduct[]>`SELECT * FROM fc_ListCatalogpProducts(
          p_page := ${paginate.page}::INTEGER,
          p_limit := ${paginate.lim}::INTEGER,
          p_search := ${paginate.search}::TEXT,
          p_category := ${paginate.category}::INTEGER
      );`
    ]);

    return { 
      total: count[0].fc_countlistcatalogproducts, 
      items: ProductMapper.toListCatalogItemDtoList(products)
    };
  }

  async getId(id: number): Promise<ProductByIdResponseDto> {
    const [ product ] = await prisma.$queryRaw<RawProductById[]>`
        SELECT * FROM fc_ProductById(
        p_product_id := ${id}::integer
    );`;

    if (!product) throw CustomError.notFound('Product not found');

    return ProductMapper.toItemDto(product);
  }

  async update(updateProduct: UpdateProductRequestDto): Promise<boolean> {
    const product = await prisma.$queryRaw`
        CALL sp_UpdateProduct(
            p_product_id:= ${updateProduct.id}::INTEGER,
            p_name:= ${updateProduct.name}::TEXT,
            p_description:= ${updateProduct.description}::TEXT,
            p_category_id:= ${updateProduct.category_id}::INTEGER,
            p_min_order_qty:= ${updateProduct.min_order_qty}::INTEGER,
            p_min_stock:= ${updateProduct.min_stock_qty}::INTEGER
        );
    `;

    return !!product;
  }

  async status(id:number): Promise<boolean> {
    const product = await this.getId(id);
    const update = await prisma.product.update({
      where: { id: id, deleted_at: null },
      data: { status: !product.status},
    });
    return !!update;
  }
  
  async image(updateImage: UpdateProductImageRequestDto): Promise<boolean> {
    await this.getId(updateImage.id);
    const user = await prisma.product.update({
      where: { id: updateImage.id, deleted_at: null },
      data: { image: updateImage.image},
    });
    return !!user;
  }
  
  async delete(id: number): Promise<boolean> {
    await this.getId(id);
    const user = await prisma.user.update({
      where: { id, deleted_at: null },
      data: { deleted_at: new Date() },
    });
    return !!user;
  }
}

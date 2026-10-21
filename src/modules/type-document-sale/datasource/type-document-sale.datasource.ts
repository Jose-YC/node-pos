import { TypeDocumentSaleResponseDto, TypeDocumentSalePaginateDto } from "../dto";
import { prisma } from "../../../config";
import { CustomError, List, OptionsDto } from "../../../shared";
import { TypeDocumentSaleOptionsRaw, TypeDocumentSaleRaw } from "../interface/type-document-sale.interface";
import { TypeDocumentSaleMapper } from "../mapper/type-document-sale.mapper";

export class TypeDocumentSaleDatasource {
    async status(id:string): Promise<boolean> {
        const document = await prisma.type_document_sale.findFirst({
            select: {
                status: true
            },
            where: {
                id
            }
        });

        if (!document) throw CustomError.notFound('This type document sale does not exist');

        const update =  await prisma.type_document_sale.update({
            data: {
                status: !document.status
            },
            where: {
               id 
            }
        });

        return !!update
    }

    async get(paginate: TypeDocumentSalePaginateDto): Promise<List<TypeDocumentSaleResponseDto>> {
        const [count, documents] = await Promise.all([
            prisma.$queryRaw<{ fc_countlisttypedocumentsales: number }[]>`
                SELECT * FROM fc_CountListTypeDocumentSales(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<TypeDocumentSaleRaw[]>`SELECT * FROM fc_ListTypeDocumentSales(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.limit}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);
        
         return { 
            total: count[0].fc_countlisttypedocumentsales, 
            items: TypeDocumentSaleMapper.toResponseDtoList(documents)
        };
    }

    async options(): Promise<OptionsDto[]> {
        const documents = await prisma.$queryRaw<TypeDocumentSaleOptionsRaw[]>`SELECT * FROM fc_ListOptionsTypeDocumentSales();`
        return TypeDocumentSaleMapper.toResponseOptionsDto(documents);
    }   
    
}
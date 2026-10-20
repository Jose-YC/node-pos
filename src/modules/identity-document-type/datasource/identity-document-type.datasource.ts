import { IdentityDocumentTypeResponseDto, IdentityDocumentTypePaginateDto } from "../dto";
import { IdentityDocumentTypeMapper } from "../mapper/type-document-sale.mapper";
import { IdentityDocumentTypeRaw, IdentityDocumentTypeOptionsRaw } from "../interface/identity-document-type.interface";
import { prisma } from "../../../config";
import { CustomError, List, OptionsDto } from "../../../shared";

export class IdentityDocumentTypeDatasource {
    async status(id:string): Promise<boolean> {
        const document = await prisma.identity_document_type.findFirst({
            select: {
                status: true
            },
            where: {
                id
            }
        });

        if (!document) throw CustomError.notFound('This identity document type does not exist');

        const update =  await prisma.identity_document_type.update({
            data: {
                status: !document.status
            },
            where: {
                id 
            }
        });

        return !!update
    }
    async get(paginate: IdentityDocumentTypePaginateDto): Promise<List<IdentityDocumentTypeResponseDto>> {
        const [count, documents] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistidentitydocumenttypes: number }[]>`
                SELECT * FROM fc_CountListIdentityDocumentTypes(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<IdentityDocumentTypeRaw[]>`SELECT * FROM fc_ListIdentityDocumentTypes(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.limit}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistidentitydocumenttypes, 
            items: IdentityDocumentTypeMapper.toResponseDtoList(documents)
        };
    }

    async options(): Promise<OptionsDto[]> {
        const documents = await prisma.$queryRaw<IdentityDocumentTypeOptionsRaw[]>`SELECT * FROM fc_ListOptionsIdentityDocumentTypes();`
        return IdentityDocumentTypeMapper.toResponseOptionsDto(documents);
    }
}
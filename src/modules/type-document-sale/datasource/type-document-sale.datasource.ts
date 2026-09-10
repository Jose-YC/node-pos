import { TypeDocumentSaleResponseDto, TypeDocumentSaleStatusResponseDto } from "../dto";
import { prisma } from "../../../config";
import { CustomError } from "../../../shared";

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

    async getAll(): Promise<TypeDocumentSaleResponseDto[]> {
        const documents = await prisma.type_document_sale.findMany({
            select:{
                id: true,
                name: true
            },
            where: {
                deleted_at: null,
                status: true
            },
            orderBy: {
                created_at: "desc",
            },
        });

        return documents.map(
            (document) =>
            new TypeDocumentSaleResponseDto(document.id, document.name)
        );
    }

    async getStatus(): Promise<TypeDocumentSaleStatusResponseDto[]> {
        const documents = await prisma.type_document_sale.findMany({
            select:{
                id: true,
                name: true,
                status: true
            },
            where: {
                deleted_at: null
            },
            orderBy: {
                created_at: "desc",
            },
        });

        return documents.map(
            (document) =>
            new TypeDocumentSaleStatusResponseDto(document.id, document.name, document.status)
        );
    }
}
import { IdentityDocumentTypeResponseDto } from "../dto/response/identity-document-type.list";
import { prisma } from "../../../config";

export class IdentityDocumentTypeDatasource {
    async get(): Promise<IdentityDocumentTypeResponseDto[]> {
        const documents = await prisma.identity_document_type.findMany({
            where: {
                deleted_at: null,
            },
            orderBy: {
                created_at: "desc",
            },
        });

        return documents.map(
            (document) =>
            new IdentityDocumentTypeResponseDto(document.id, document.name)
        );
    }
}
import { IdentityDocumentTypeOptionsRaw, IdentityDocumentTypeRaw } from "../interface/identity-document-type.interface";
import { IdentityDocumentTypeResponseDto } from "../dto";
import { OptionsDto } from "../../../shared";

export class IdentityDocumentTypeMapper {
    static toResponseDto(identityDocumentType: IdentityDocumentTypeRaw): IdentityDocumentTypeResponseDto {
      return {
        id: identityDocumentType.id,
        name: identityDocumentType.name,
        code: identityDocumentType.code,
        short_name: identityDocumentType.short_name,
        status: identityDocumentType.status,
      };
    }

    static toResponseOptionsDto(identityDocumentTypes: IdentityDocumentTypeOptionsRaw[]): OptionsDto[] {
        return identityDocumentTypes.map(identityDocumentType => ({
            id: identityDocumentType.id,
            label: identityDocumentType.name,
        }));
    }

    static toResponseDtoList(identityDocumentTypes: IdentityDocumentTypeRaw[]): IdentityDocumentTypeResponseDto[] {
        return identityDocumentTypes.map(identityDocumentType => this.toResponseDto(identityDocumentType));
    }
}
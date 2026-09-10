import { UserListItemDto } from "../../user/dto";
import { AuthResponseDto } from "../dto";

interface User {
  id: number;
  name: string;
  email: string;
  image?: string;
}

export class AuthResponseMapper {
  static toDto(token: string, user: User): AuthResponseDto {
    
    const userDto = {
      id: user.id,
      name: user.name.trim(),
      email: user.email.trim(),
      img: user.image?.trim() || undefined,
    } as const satisfies UserListItemDto;

    return {
      token: token.trim(),
      user: userDto,
    };
  }
}
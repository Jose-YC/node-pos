import { CategoryResponseDto } from "../dto";
import { CategoryRaw } from "../interface/category.interface";

export class CategoryMapper {
    static toResponseDto(Category: CategoryRaw): CategoryResponseDto {
      return {
        id: Category.id,
        name: Category.name.trim(),
        description: Category.description?.trim(),
      };
    }

    static toResponseDtoList(Categorys: CategoryRaw[]): CategoryResponseDto[] {
        return Categorys.map(Category => this.toResponseDto(Category));
    }
}
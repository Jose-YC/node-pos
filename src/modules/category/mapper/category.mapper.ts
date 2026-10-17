import { OptionsDto } from "../../../shared";
import { CategoryResponseDto } from "../dto";
import { CategoryOptionsRaw, CategoryRaw } from "../interface/category.interface";

export class CategoryMapper {
    static toResponseDto(category: CategoryRaw): CategoryResponseDto {
      return {
        id: category.id,
        name: category.name.trim(),
        description: category.description?.trim(),
      };
    }

    static toResponseOptionsDto(categories: CategoryOptionsRaw[]): OptionsDto[] {
        return categories.map(category => ({
            id: category.id,
            label: category.name,
        }));
    }

    static toResponseDtoList(categories: CategoryRaw[]): CategoryResponseDto[] {
        return categories.map(category => this.toResponseDto(category));
    }
}
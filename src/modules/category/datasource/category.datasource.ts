import { prisma } from '../../../config';
import { List, CustomError } from '../../../shared';
import { CreateCategoryRequestDto, CategoryResponseDto, UpdateCategoryRequestDto, CategoryPaginateDto } from '../dto';
import { CategoryRaw } from '../interface/category.interface'
import { CategoryMapper } from '../mapper/category.mapper';

export class CategoryDatasource {

    async create(createCategory: CreateCategoryRequestDto): Promise<boolean> {
        const existingCategory = await prisma.category.findFirst({where: { name: createCategory.name }});
        if (existingCategory) throw CustomError.badRequest('A Category with this name already exists');

        const category = await prisma.category.create({data: createCategory!});
        return !!category;
    }
    
    async get(paginate:CategoryPaginateDto): Promise<List<CategoryResponseDto>> {
        const start = performance.now();
        const [count, categories] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistcategorys: number }[]>`
                SELECT * FROM fc_CountListCategorys(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<CategoryRaw[]>`SELECT * FROM fc_ListCategorys(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);
        console.log(`[controller query] ${performance.now() - start}ms`);
        
        return { 
            total: count[0].fc_countlistcategorys, 
            items: CategoryMapper.toResponseDtoList(categories)
        };
    }

    async getId(id: number): Promise<CategoryResponseDto> {
        const category = await prisma.category.findFirst({
            select: {
                id: true,
                name: true,
                description: true
            },
            where: {
                id, 
                deleted_at:null 
            }
        });
        if (!category) throw CustomError.notFound('This category does not exist');

        return CategoryMapper.toResponseDto({
            id: category.id, 
            name: category.name, 
            description: category.description || undefined
        });
    }
    
    async update(updateCategory: UpdateCategoryRequestDto): Promise<boolean> {
        await this.getId(updateCategory.id);

        if (updateCategory.name) {
            const existingCategory = await prisma.category.findFirst({where: { name: updateCategory.name, id: { not: updateCategory.id } }});
            if (existingCategory) throw CustomError.badRequest('A category with this name already exists');
        }

        const update = await prisma.category.update({where: {id: updateCategory.id, deleted_at:null}, data: updateCategory!.values});
        return !!update;
    }
    
    async delete(id: number): Promise<boolean> {
        await this.getId(id);
        const category = await prisma.category.update({where: { id, deleted_at:null }, data: {deleted_at: new Date()}});
        return !!category;
    }
}
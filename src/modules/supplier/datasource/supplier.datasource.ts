import { prisma } from '../../../config';
import { List, CustomError } from '../../../shared';
import { CreateSupplierRequestDto, SupplierResponseDto, UpdateSupplierRequestDto, SupplierPaginateDto } from '../dto';
import { SupplierRaw } from '../interface/supplier.interface'
import { SupplierMapper } from '../mapper/supplier.mapper';

export class SupplierDatasource {

    async create(createSupplier: CreateSupplierRequestDto): Promise<boolean> {
        const supplier = await prisma.supplier.create({data: createSupplier});
        return !!supplier;
    }
    
    async get(paginate:SupplierPaginateDto): Promise<List<SupplierResponseDto>> {
        const [count, suppliers] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistsuppliers: number }[]>`
                SELECT * FROM fc_CountListSuppliers(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<SupplierRaw[]>`SELECT * FROM fc_ListSuppliers(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistsuppliers, 
            items: SupplierMapper.toResponseDtoList(suppliers)
        };
    }

    async getId(id: number): Promise<SupplierResponseDto> {
        const supplier = await prisma.supplier.findFirst({
            select: {
                id: true,
                name: true,
                type: true,
                ruc: true,
                email: true,
                phone: true
            },
            where: {
                id, 
                deleted_at:null 
            }
        });
        if (!supplier) throw CustomError.notFound('This supplier does not exist');

        return SupplierMapper.toResponseDto({
            id: supplier.id, 
            name: supplier.name, 
            type: supplier.type,
            ruc: supplier.ruc,
            email: supplier.email || undefined,
            phone: supplier.phone || undefined
        });
    }
    
    async update(updateSupplier: UpdateSupplierRequestDto): Promise<boolean> {
        await this.getId(updateSupplier.id);

        const update = await prisma.supplier.update({where: {id: updateSupplier.id, deleted_at:null}, data: updateSupplier!.values});
        return !!update;
    }
    
    async delete(id: number): Promise<boolean> {
        await this.getId(id);
        const supplier = await prisma.supplier.update({where: { id, deleted_at:null }, data: {deleted_at: new Date()}});
        return !!supplier;
    }
}
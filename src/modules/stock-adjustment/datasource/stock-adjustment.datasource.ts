
import { CreateStockAdjustmentRequestDto, StockAdjustmentListItemDto, UpdateStockAdjustmentRequestDto, StockAdjustmentPaginateDto, StockAdjustmentResponseDto } from '../dto';
import { StockAdjustmentByIdRaw, StockAdjustmentRaw } from "../interface/stock-adjustment.interface";
import { List, CustomError } from '../../../shared';
import { StockAdjustmentMapper } from '../mapper/stock-adjustment.mapper';  
import { prisma } from '../../../config';

export class StockAdjustmentDatasource {

    async create(createStockAdjustment: CreateStockAdjustmentRequestDto): Promise<boolean> {
        const items = JSON.stringify(createStockAdjustment.items);

        const stockAdjustment = await prisma.$queryRaw`
            CALL sp_CreateStockAdjustment(
                p_user_id := ${createStockAdjustment.userid}::integer,
                p_reason_id := ${createStockAdjustment.reason_id}::integer,
                p_items := ${items}::jsonb,
                p_notes := ${createStockAdjustment.notes}::text
            );
        `;

        return !!stockAdjustment;
    }

    async get(paginate:StockAdjustmentPaginateDto): Promise<List<StockAdjustmentListItemDto>> {

        const [count, stockAdjustments] = await Promise.all([
            prisma.$queryRaw<{ fc_countliststockadjustment: number }[]>`
                SELECT * FROM fc_CountListStockAdjustment(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<StockAdjustmentRaw[]>`SELECT * FROM fc_ListStockAdjustment(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countliststockadjustment, 
            items: StockAdjustmentMapper.toListItemDtoArray(stockAdjustments)
        };
    }

    async getId(id: number): Promise<StockAdjustmentResponseDto> {
        const adjustment = await prisma.stock_adjustment.findFirst({
            where: {
                id
            },
            select: {
                id: true,
                serie: true,
                status: true,
                stock_adjustment_date: true,
                reason_id: true,
                reason_name: true,
                direction: true,
                notes: true,
                total_qty: true,
                total_value: true,
                detailStockAdjustments: {
                select: {
                    product_id: true,
                    product_name: true,
                    qty: true,
                    valuation_rate: true,
                    subtotal: true,
                },
                },
            },
        });

        if (!adjustment) throw CustomError.notFound('Stock Adjustment not found');

        return StockAdjustmentMapper.toResponseDto(adjustment as StockAdjustmentByIdRaw);
    }

    async update(updateStockAdjustment: UpdateStockAdjustmentRequestDto): Promise<boolean> {
        const permissions = updateStockAdjustment.items ? JSON.stringify(updateStockAdjustment.items) : null;

        const stockAdjustment = await prisma.$queryRaw`
            CALL sp_UpdateStockAdjustment(
            p_stock_adjustment_id := ${updateStockAdjustment.id}::integer,
            p_reason_id := ${updateStockAdjustment.reason_id}::integer,
            p_notes := ${updateStockAdjustment.notes}::text,
            p_items := ${permissions}::jsonb
        );`;

        return !!stockAdjustment;
    }

    async submit(id: number): Promise<boolean> {
        const stockAdjustment = await prisma.$queryRaw`
            CALL sp_ConfirmStockAdjustment(
                p_stock_adjustment_id := ${id}::integer
            );
        `;

        return !!stockAdjustment;
    }
    
    async delete(id: number): Promise<boolean> {
        const stockAdjustmentExists = await prisma.stock_adjustment.findFirst({ select: { status: true }, where: { id, deleted_at: null }});
        
        if (!stockAdjustmentExists) throw CustomError.notFound('Stock Adjustment not found');
        if(stockAdjustmentExists.status === 'confirmado') throw CustomError.badRequest('Stock Adjustment is borrador and cannot be deleted');

        const stockAdjustment = await prisma.stock_adjustment.delete({where: { id, deleted_at: null }});
        return !!stockAdjustment;
    }
}       
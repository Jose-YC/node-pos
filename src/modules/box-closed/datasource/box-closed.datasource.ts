
import { ClosedBoxDResponseDto, CreateBoxClosedRequestDto } from '../dto';
import { BoxClosedByIdRaw } from "../interface/box-closed.interface";
import { List, CustomError } from '../../../shared';
import { BoxClosedMapper } from '../mapper/box-cloded.mapper';  
import { prisma } from '../../../config';

export class BoxClosedDatasource {
    async closed(create: CreateBoxClosedRequestDto): Promise<boolean> {
        const closed = await prisma.$queryRaw`
            CALL sp_ClosedBox(
                p_user_id := ${create.userid}::INTEGER,
                p_box_open_id := ${create.box_open_id}::INTEGER,
                p_amount_cash := ${create.amount_cash}::NUMERIC,
                p_notes := ${create.note}::VARCHAR
            );
        `;
        return !!closed;
    }

    async getId(id: number): Promise<ClosedBoxDResponseDto> {
        const boxClosed = await prisma.box_closed.findFirst({
            where: {
                id
            },
            select: {
                id: true,
                serie: true,
                status: true,
                start_date: true,
                end_date: true,
                notes: true,
                detailBoxesClose: {
                    select: {
                        mode_payment: true,
                        mode_payment_name: true,
                        opening_amount: true,
                        expected_amount: true,
                        closing_amount: true,
                        difference_amount: true,
                    }
                }
            }
        });

        if (!boxClosed) throw CustomError.notFound('Box closed not found');

        return BoxClosedMapper.toResponseDto(boxClosed as BoxClosedByIdRaw);
    }
}
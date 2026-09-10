
import { CreateBoxOpenRequestDto, BoxOpenListItemDto, BoxOpenPaginateDto } from '../dto';
import { BoxOpenRaw } from "../interface/box-open.interface";
import { List, CustomError } from '../../../shared';
import { BoxOpenMapper } from '../mapper/box-open.mapper';  
import { prisma } from '../../../config';

export class BoxOpenDatasource {

    async open(createBoxOpen: CreateBoxOpenRequestDto): Promise<boolean> {
        const box = await prisma.$queryRaw`
            CALL sp_OpenBox(
            p_userid := ${createBoxOpen.userid}::INTEGER,
            p_amount_cash := ${createBoxOpen.amount_cash}::NUMERIC,
            p_notes := ${createBoxOpen.note}::TEXT
        );`;

        return !!box;
    }

    async get(paginate:BoxOpenPaginateDto): Promise<List<BoxOpenListItemDto>> {

        const [count, boxs] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistboxs: number }[]>`
                SELECT * FROM fc_CountListBoxs(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<BoxOpenRaw[]>`SELECT * FROM fc_ListBoxs(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistboxs, 
            items: BoxOpenMapper.toListItemDtoArray(boxs)
        };
    }
}
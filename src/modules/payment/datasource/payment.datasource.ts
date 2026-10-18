import { prisma } from '../../../config';
import { List, CustomError, OptionsDto } from '../../../shared';
import { CreatePaymentRequestDto, PaymentResponseDto, UpdatePaymentRequestDto, PaymentPaginateDto } from '../dto';
import { PaymentOptionsDto } from '../dto/request/payment.option';
import { PaymentRaw, PaymentType } from '../interface/payment.interface'
import { PaymentMapper } from '../mapper/payment.mapper';

export class PaymentDatasource {

    async create(createPayment: CreatePaymentRequestDto): Promise<boolean> {
        const existingPayment = await prisma.payment.findFirst({where: { type: createPayment.type }});
        if (existingPayment) throw CustomError.badRequest('A payment with this name already exists');

        const payment = await prisma.payment.create({data: createPayment!});
        return !!payment;
    }
    
    async get(paginate:PaymentPaginateDto): Promise<List<PaymentResponseDto>> {
        const [count, payments] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistpayments: number }[]>`
                SELECT * FROM fc_CountListPayments(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<PaymentRaw[]>`SELECT * FROM fc_ListPayments(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistpayments, 
            items: PaymentMapper.toResponseDtoList(payments)
        };
    }

    async options(options: PaymentOptionsDto): Promise<OptionsDto[]> {
        const payments = await prisma.$queryRaw<PaymentRaw[]>`SELECT * FROM fc_ListOptionsPayments(
            lim := ${5}::integer,
            search := ${options.search}::TEXT
        );`
        
        return PaymentMapper.toResponseOptionsDto(payments);
    }

    async getId(id: number): Promise<PaymentResponseDto> {
        const payment = await prisma.payment.findFirst({
            select: {
                id: true,
                name: true,
                type: true,
                status: true
            },
            where: {
                id, 
                deleted_at:null 
            }
        });
        if (!payment) throw CustomError.notFound('This payment does not exist');

        return PaymentMapper.toResponseDto({
            id: payment.id, 
            name: payment.name, 
            type: payment.type as PaymentType,
            status: payment.status
        });
    }
    
    async update(updatePayment: UpdatePaymentRequestDto): Promise<boolean> {
        await this.getId(updatePayment.id);

        const update = await prisma.category.update({where: {id: updatePayment.id, deleted_at:null}, data: updatePayment!.values});
        return !!update;
    }

    async status(id: number): Promise<boolean> {
        const payment = await this.getId(id);
        const update = await prisma.payment.update({where: { id, deleted_at:null }, data: {status: !payment.status}});
        return !!update;
    }
    
    async delete(id: number): Promise<boolean> {
        await this.getId(id);
        const payment = await prisma.category.update({where: { id, deleted_at:null }, data: {deleted_at: new Date()}});
        return !!payment;
    }
}
import { prisma } from '../../../config';
import { List, CustomError } from '../../../shared';
import { CreateCustomerRequestDto, CustomerResponseDto, UpdateCustomerRequestDto, CustomerPaginateDto } from '../dto';
import { CustomerRaw } from '../interface/customer.interface'
import { CustomerMapper } from '../mapper/customer.mapper';

export class CustomerDatasource {

    async create(createCustomer: CreateCustomerRequestDto): Promise<boolean> {
        const customer = await prisma.$queryRaw`
                CALL sp_CreateCustomer(
                p_name := ${createCustomer.name}::TEXT,
                p_doc_type_code := ${createCustomer.doc_code}::TEXT,
                p_doc_type_number := ${createCustomer.doc_number}::TEXT,
                p_email := ${createCustomer.email}::TEXT,
                p_phone := ${createCustomer.name}::TEXT,
        );`;
        
        return !!customer;
    }
    
    async get(paginate:CustomerPaginateDto): Promise<List<CustomerResponseDto>> {
        const [count, customers] = await Promise.all([
            prisma.$queryRaw<{ fc_countlistcustomers: number }[]>`
                SELECT * FROM fc_CountListCustomers(
                p_search := ${paginate.search}::TEXT
            );`,

            prisma.$queryRaw<CustomerRaw[]>`SELECT * FROM fc_ListCustomers(
                p_page := ${paginate.page}::integer,
                p_limit := ${paginate.lim}::integer,
                p_search := ${paginate.search}::TEXT
            );`
        ]);

        return { 
            total: count[0].fc_countlistcustomers, 
            items: CustomerMapper.toResponseDtoList(customers)
        };
    }

    async getId(id: number): Promise<CustomerResponseDto> {
        const customer = await prisma.customer.findFirst({
            select: {
                id: true,
                name: true,
                doc_type_code: true,
                doc_type_name: true,
                doc_type_number: true,
                email: true,
                phone: true
            },
            where: {
                id, 
                deleted_at:null 
            }
        });
        if (!customer) throw CustomError.notFound('Este cliente no existe.');

        return CustomerMapper.toResponseDto({
            id: customer.id, 
            name: customer.name, 
            doc_code: customer.doc_type_code,
            doc_type: customer.doc_type_name,
            doc_number: customer.doc_type_number,
            email: customer.email || undefined,
            phone: customer.phone || undefined
        });
    }
    
    async update(updateCustomer: UpdateCustomerRequestDto): Promise<boolean> {
        const update = await prisma.$queryRaw`
                CALL sp_UpdateCustomer(
                p_customer_id := ${updateCustomer.id}::INTEGER,
                p_name := ${updateCustomer.name}::TEXT,
                p_doc_type_code := ${updateCustomer.doc_code}::TEXT,
                p_doc_type_number := ${updateCustomer.doc_number}::TEXT,
                p_email := ${updateCustomer.email}::TEXT,
                p_phone := ${updateCustomer.name}::TEXT,
        );`;
        
        return !!update;
    }
    
    async delete(id: number): Promise<boolean> {
        await this.getId(id);
        const customer = await prisma.customer.update({where: { id, deleted_at:null }, data: {deleted_at: new Date()}});
        return !!customer;
    }
}
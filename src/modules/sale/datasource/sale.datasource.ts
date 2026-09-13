import { CreateSaleRequestDto, SalePaginateDto, SaleListItemDto, CreateCreditNoteRequestDto, SaleResponseDto } from "../dto";
import { prisma } from "../../../config";
import { CustomError, List } from "../../../shared";
import { SaleByIdRaw, SaleRaw } from "../interface/sale.inerface";
import { SaleMapper } from "../mapper/sale.mapper";

export class SaleDatasource {
  async create(createSale: CreateSaleRequestDto, typeSale: string): Promise<boolean> {
    const items = JSON.stringify(createSale.items);
    const payments = JSON.stringify(createSale.payment);

    const customerId = createSale.customer?.customer_id ?? null;
    const customerName = createSale.customer?.customer_name ?? null;
    const customerType = createSale.customer?.customer_type ?? null;
    const customerNumber = createSale.customer?.customer_number ?? null;

    const sale = await prisma.$queryRaw`
        CALL sp_CreateSale(
            p_user_id := ${createSale.userid}::INTEGER,
            p_document_type_sale_id := ${typeSale}::VARCHAR,
            p_box_open_id := ${createSale.box_open_id}::INTEGER,
            p_paid_amount := ${createSale.paid_amount}::NUMERIC,
            p_items := ${items}::JSONB,
            p_payment := ${payments}::JSONB,
            p_customer_id := ${customerId}::INTEGER,
            p_customer_name := ${customerName}::VARCHAR,
            p_customer_type_code := ${customerType}::VARCHAR,
            p_customer_type_number := ${customerNumber}::VARCHAR
        );
    `;
    return !!sale;
  }

  async creditNote(createCreditNote: CreateCreditNoteRequestDto): Promise<boolean> {
    const items = JSON.stringify(createCreditNote.items);
    const payments = JSON.stringify(createCreditNote.payment);

    const note = await prisma.$queryRaw`
        CALL sp_CreateCreditNote(
            p_user_id := ${createCreditNote.userid}::INTEGER,
            p_sale_id := ${createCreditNote.saleid}::INTEGER,
            p_paid_amount := ${createCreditNote.paid_amount}::NUMERIC,
            p_box_open_id := ${createCreditNote.box_open_id}::INTEGER,
            p_items := ${items}::JSONB,
            p_payment := ${payments}::JSONB,
            p_notes := ${createCreditNote.notes}::VARCHAR
        );
    `;
    return !!note;
  }
  
  async get(paginate: SalePaginateDto): Promise<List<SaleListItemDto>> {
    const [count, users] = await Promise.all([
      prisma.$queryRaw<{ fc_countlistsale: number }[]>`
          SELECT * FROM fc_CountListSale(
          p_search := ${paginate.search}::TEXT,
          p_userid := ${paginate.userid}::INTEGER
      );`,

      prisma.$queryRaw<SaleRaw[]>`SELECT * FROM fc_ListSale(
          p_page := ${paginate.page}::INTEGER,
          p_limit := ${paginate.lim}::INTEGER,
          p_search := ${paginate.search}::TEXT,
          p_userid := ${paginate.userid}::INTEGER
      );`
    ]);

    return { 
      total: count[0].fc_countlistsale, 
      items: SaleMapper.toListItemDtoArray(users)
    };
  }

  async getId(id: number): Promise<SaleResponseDto> {
    const sale = await prisma.sale.findFirst({
      where: {
        id
      },
      select: {
        id: true,
        sale_date: true,
        serie: true,
        type_code: true,
        customer_name: true,
        customer_doc_code: true,
        customer_doc_number: true,
        igv_rate: true,
        taxable_amount: true,
        igv_total: true,
        total: true,
        paid_amount: true,
        change_amount: true,
        is_return: true,
        return_against_id: true,
        detailSales: {
          select: {
            product_id: true,
            product_name: true,
            qty: true,
            price: true,
            subtotal: true,
          },
        },
        salePayments: {
          select: {
            payment_id: true,
            payment_name: true,
            amount: true,
          },
        },
      },
    });

    if (!sale) throw CustomError.notFound('Sale not found');

    return SaleMapper.toResponseDto(sale as SaleByIdRaw);
  }
}

import {
  CreateReceiptPurchaseRequestDto,
  UpdateReceiptPurchaseRequestDto,
  ReceiptPurchaseListItemDto,
  ReceiptPurchasePaginateDto,
  ReceiptPurchaseResponseDto
} from "../dto";
import { ReceiptPurchaseByIdRaw, ReceiptPurchaseRaw } from "../interface/receipt-purchase.interface";
import { ReceiptPurchaseMapper } from "../mapper/receipt-purchase.mapper";
import { prisma } from "../../../config";
import { CustomError, List } from "../../../shared";

export class ReceiptPurchaseDatasource {
  async create(createReceiptPurchase: CreateReceiptPurchaseRequestDto): Promise<boolean> {
     const items = JSON.stringify(createReceiptPurchase.items);
    const receipt = await prisma.$queryRaw`
            CALL sp_CreateReceiptPurchase(
            p_purchase_id := ${createReceiptPurchase.purchaseid}::INTEGER,
            p_userid := ${createReceiptPurchase.userid}::INTEGER,
            p_items := ${items}::JSONB
    );`;
    
    return !!receipt;
  }

  async get(paginate: ReceiptPurchasePaginateDto): Promise<List<ReceiptPurchaseListItemDto>> {
    const [count, users] = await Promise.all([
      prisma.$queryRaw<{ fc_countlistreceiptpurchase: number }[]>`
          SELECT * FROM fc_CountListReceiptPurchase(
          p_search := ${paginate.search}::TEXT
      );`,

      prisma.$queryRaw<ReceiptPurchaseRaw[]>`SELECT * FROM fc_ListReceiptPurchase(
          p_page := ${paginate.page}::INTEGER,
          p_limit := ${paginate.lim}::INTEGER,
          p_search := ${paginate.search}::TEXT
      );`
    ]);

    return { 
      total: count[0].fc_countlistreceiptpurchase, 
      items: ReceiptPurchaseMapper.toListItemDtoArray(users)
    };
  }

  async getId(id: number): Promise<ReceiptPurchaseResponseDto> {
    const receipt = await prisma.receipt_purchase.findFirst({
      where: {
        id
      },
      select: {
        id: true,
        serie: true,
        status: true,
        supplier_id: true,
        supplier_ruc: true,
        supplier_name: true,
        date_receipt: true,
        note: true,
        total: true,
        detailReceiptPurchases: {
          select: {
            product_id: true,
            product_name: true,
            qty_received: true,
            qty_reject: true,
            qty_accepted: true,
            price: true,
            subtotal: true,
            detail_order_purchase: {
              select: {
                qty_received: true,
              },
            },
          }
        }
      },
    });

    if (!receipt) throw CustomError.notFound('Receipt Purchase not found');

    return ReceiptPurchaseMapper.toResponseDto(receipt as ReceiptPurchaseByIdRaw);
  }

  async update(update: UpdateReceiptPurchaseRequestDto): Promise<boolean> {
    const items =  JSON.stringify(update.items);
    
    const order = await prisma.$queryRaw`
            CALL sp_UpdateReceiptPurchase(
            p_receipt_id := ${update.id}::INTEGER,
            p_items := ${items}::JSONB
    );`;

    return !!order;
  }

  async submit(id: number): Promise<boolean> {
     const updateReceipt = await prisma.$queryRaw`
            CALL sp_ConfirmReceiptPurchase(
            p_receipt_id := ${id}::INTEGER
    );`;
    
    return !!updateReceipt;
  }
  
  async delete(id: number): Promise<boolean> {
    const receipt = await prisma.receipt_purchase.findFirst({ select:{ status: true }, where:{ id } });
    
    if (!receipt) throw CustomError.notFound('Recepcion de Compra no encontrada');
    if (receipt.status !== 'borrador') throw CustomError.notFound('La Recepcion de Compra no esta con estado de borrador');

    const deleteReceipt = await prisma.order_purchase.delete({ where: { id } });
    
    return !!deleteReceipt;
  }
}

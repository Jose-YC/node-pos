import {
  CreateOrderPurchaseRequestDto,
  UpdateOrderPurchaseRequestDto,
  OrderPurchaseListItemDto,
  OrderPurchasePaginateDto,
  OrderPurchaseResponseDto
} from "../dto";
import { OrderPurchaseRaw, OrderPurchaseByIdRaw } from "../interface/order-purchase.interface";
import { OrderPurchaseMapper } from "../mapper/order-purchase.mapper";
import { prisma } from "../../../config";
import { CustomError, List } from "../../../shared";

export class OrderPurchaseDatasource {
  async create(createOrderPurchase: CreateOrderPurchaseRequestDto): Promise<boolean> {
     const items = JSON.stringify(createOrderPurchase.items);
    const order = await prisma.$queryRaw`
            CALL sp_CreateOrderPurchase(
            p_userid := ${createOrderPurchase.userid}::INTEGER,
            p_supplierid := ${createOrderPurchase.supplier_id}::INTEGER,
            p_address := ${createOrderPurchase.address}::TEXT,
            p_delivery_date := ${createOrderPurchase.delivery_date}::DATE,
            p_items := ${items}::JSONB
    );`;
    
    return !!order;
  }

  async get(paginate: OrderPurchasePaginateDto): Promise<List<OrderPurchaseListItemDto>> {
    const [count, users] = await Promise.all([
      prisma.$queryRaw<{ fc_countlistorderpurchase: number }[]>`
          SELECT * FROM fc_CountListOrderPurchase(
          p_search := ${paginate.search}::TEXT
      );`,

      prisma.$queryRaw<OrderPurchaseRaw[]>`SELECT * FROM fc_ListOrderPurchase(
          p_page := ${paginate.page}::INTEGER,
          p_limit := ${paginate.lim}::INTEGER,
          p_search := ${paginate.search}::TEXT
      );`
    ]);

    return { 
      total: count[0].fc_countlistorderpurchase, 
      items: OrderPurchaseMapper.toListItemDtoArray(users)
    };
  }

  async getId(id: number): Promise<OrderPurchaseResponseDto> {
    const order = await prisma.order_purchase.findFirst({
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
        address_purchase: true,
        delivery_date: true,
        total: true,
        detailOrderPurchases: {
          select: {
            product_id: true,
            product_name: true,
            qty_received: true,
            qty: true,
            price: true,
            subtotal: true,
          }
        }
      },
    });
    return OrderPurchaseMapper.toResponseDto(order as OrderPurchaseByIdRaw);
  }

  async update(update: UpdateOrderPurchaseRequestDto): Promise<boolean> {
    const items = update.items ? JSON.stringify(update.items) : null;
    
    const order = await prisma.$queryRaw`
            CALL sp_UpdateOrderPurchase(
            p_purchase_id := ${update.id}::INTEGER,
            p_supplierid := ${update.supplier_id}::INTEGER,
            p_address := ${update.address}::TEXT,
            p_delivery_date := ${update.delivery_date}::DATE,
            p_items := ${items}::JSONB
    );`;

    return !!order;
  }

  async send(id: number): Promise<boolean> {
    const order = await prisma.order_purchase.findFirst({ select:{ status: true }, where:{ id } });
    
    if (!order) throw CustomError.notFound('Orden de Compra no encontrada');
    if (order.status !== 'borrador') throw CustomError.notFound('La Orden de Compra no esta con estado de borrador');

    const updateOrder = await prisma.order_purchase.update({ where: { id }, data:{ status: 'enviado' } });
    
    return !!updateOrder;
  }

  async draft(id: number): Promise<boolean> {
    const order = await prisma.order_purchase.findFirst({ select:{ status: true }, where:{ id } });
    
    if (!order) throw CustomError.notFound('Orden de Compra no encontrada');
    if (order.status !== 'enviado') throw CustomError.notFound('La Orden de Compra no esta con estado de enviado');

    const updateOrder = await prisma.order_purchase.update({ where: { id }, data:{ status: 'borrador' } });
    
    return !!updateOrder;
  }

  async submit(id: number): Promise<boolean> {
    const order = await prisma.order_purchase.findFirst({ select:{ status: true }, where:{ id } });
    
    if (!order) throw CustomError.notFound('Orden de Compra no encontrada');
    if (order.status !== 'enviado') throw CustomError.notFound('La Orden de Compra no esta con estado de enviado');

    const updateOrder = await prisma.order_purchase.update({ where: { id }, data:{ status: 'aprobado' } });
    
    return !!updateOrder;
  }
  
  async delete(id: number): Promise<boolean> {
    const order = await prisma.order_purchase.findFirst({ select:{ status: true }, where:{ id } });
    
    if (!order) throw CustomError.notFound('Orden de Compra no encontrada');
    if (order.status !== 'borrador') throw CustomError.notFound('La Orden de Compra no esta con estado de borrador');

    const deleteOrder = await prisma.order_purchase.delete({ where: { id } });
    
    return !!deleteOrder;
  }
}

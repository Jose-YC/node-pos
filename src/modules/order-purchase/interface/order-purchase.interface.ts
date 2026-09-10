export interface OrderPurchaseRaw {
    id: number;
    serie: string;
    status: string;
    supplier_ruc: string;
    supplier_name:string
    delivery_date:Date
    total:number
}
type NumericValue = number | { toNumber(): number } | any;

export interface OrderPurchaseDetailRaw {
    id: number;
    product_id: number;
    product_name:string
    qty_received:number
    qty:number
    price:NumericValue
    subtotal:NumericValue
}
export interface OrderPurchaseByIdRaw {
    id: number;
    serie: string;
    status: string;
    supplier_id: number;
    supplier_ruc: string;
    supplier_name:string
    address_purchase:string
    delivery_date:Date
    total:NumericValue
    detailOrderPurchases: OrderPurchaseDetailRaw[]
}


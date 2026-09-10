import { Router } from "express";
import { AuthRoutes, PermissionRoutes, RoleRoutes, 
         UserRoutes, ImageRoutes, CategoryRoutes, 
         SupplierRoutes, CustomerRoutes, PaymentRoutes,
         ProductRoutes, OrderPurchaseRoutes, ReceiptPurchaseRoutes,
         IdentityDocumentTypeRoutes, TypeDocumentSaleRoutes,
         BoxOpenRoutes, SaleRoutes, StockAdjustmentRoutes,
         BoxClosedRoutes } from "../modules";

export class AppRoutes {

    static get routes():Router{
        const router = Router();
        router.use('/auth', AuthRoutes.routes);
        router.use('/user', UserRoutes.routes);
        router.use('/rol', RoleRoutes.routes);
        router.use('/permission', PermissionRoutes.routes);
        router.use('/image', ImageRoutes.routes);
        router.use('/category', CategoryRoutes.routes);
        router.use('/supplier', SupplierRoutes.routes);
        router.use('/customer', CustomerRoutes.routes);
        router.use('/payment', PaymentRoutes.routes);
        router.use('/product', ProductRoutes.routes);
        router.use('/order-purchase', OrderPurchaseRoutes.routes);
        router.use('/receipt-purchase', ReceiptPurchaseRoutes.routes);
        router.use('/type-document-sale', TypeDocumentSaleRoutes.routes);
        router.use('/identity-document-type', IdentityDocumentTypeRoutes.routes);
        router.use('/box-open', BoxOpenRoutes.routes);
        router.use('/box-closed', BoxClosedRoutes.routes);
        router.use('/sale', SaleRoutes.routes);
        router.use('/stock-adjustment', StockAdjustmentRoutes.routes);
        
        return router;
    }
}   
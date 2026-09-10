import { Router } from "express";
import { ReceiptPurchaseController } from "../controller/receipt-purchase.controller";
import { AuthMiddleware } from '../../../middlewares';

export class ReceiptPurchaseRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const receipt= new ReceiptPurchaseController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['receipt:read'])], receipt.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:byid'])], receipt.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['receipt:create'])], receipt.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['receipt:update'])], receipt.put);
        router.patch('/submit/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['receipt:submit'])], receipt.submit);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['receipt:delete'])], receipt.delete);
        
        return router;
    }
}
import { Router } from "express";
import { OrderPurchaseController } from "../controller/order-purchase.controller";
import { AuthMiddleware } from '../../../middlewares';

export class OrderPurchaseRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const order= new OrderPurchaseController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:read'])], order.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:byid'])], order.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:create'])], order.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:update'])], order.put);
        router.patch('/send/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:send'])], order.send);
        router.patch('/draft/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:draft'])], order.draft);
        router.patch('/submit/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:submit'])], order.submit);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['purchase:delete'])], order.delete);
        
        return router;
    }
}
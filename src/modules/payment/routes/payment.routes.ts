import { Router } from "express";
import { PaymentController } from "../controller/payment.controller";
import { AuthMiddleware } from '../../../middlewares';

export class PaymentRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const payment= new PaymentController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:read'])], payment.get);
        router.get('/options', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:options'])], payment.options);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:byid'])], payment.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:create'])], payment.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:update'])], payment.put);
        router.patch('/status/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:status'])], payment.status);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['payments:delete'])], payment.delete);
        
        return router;
    }
}
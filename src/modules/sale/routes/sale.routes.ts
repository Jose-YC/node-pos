import { Router } from "express";
import { SaleController } from "../controller/sale.controller";
import { AuthMiddleware } from '../../../middlewares';


export class SaleRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const sale= new SaleController();
        const authMiddleware = new AuthMiddleware();

        router.get('/admin', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['sale:read'])], sale.getAll);
        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['sale:readid'])], sale.getAllById);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['sale:byid'])], sale.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['sale:create'])], sale.post);
        router.post('/credit-note', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['credit-note:create'])], sale.postCreditNote);
        
        return router;
    }
}
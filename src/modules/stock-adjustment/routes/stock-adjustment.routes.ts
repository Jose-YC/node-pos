import { Router } from "express";
import { StockAdjustmentController } from "../controller/stock-adjustment.controller";
import { AuthMiddleware } from '../../../middlewares';

export class StockAdjustmentRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const adjustment= new StockAdjustmentController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['stock-adjustment:read'])], adjustment.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['stock-adjustment:byid'])], adjustment.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['stock-adjustment:create'])], adjustment.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['stock-adjustment:update'])], adjustment.put);     
        router.patch('/submit/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['stock-adjustment:submit'])], adjustment.submit);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['stock-adjustment:delete'])], adjustment.delete);
        
        return router;
    }
}
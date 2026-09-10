import { Router } from "express";
import { SupplierController } from "../controller/supplier.controller";
import { AuthMiddleware } from '../../../middlewares';

export class SupplierRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const supplier= new SupplierController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['suppliers:read'])], supplier.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['suppliers:byid'])], supplier.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['suppliers:create'])], supplier.post);
        router.put('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['suppliers:update'])], supplier.put);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['suppliers:delete'])], supplier.delete);
        
        return router;
    }
}
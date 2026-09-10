import { Router } from "express";
import { TypeDocumentSaleController } from "../controller/type-document-sale.controller";
import { AuthMiddleware } from '../../../middlewares';

export class TypeDocumentSaleRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const document = new TypeDocumentSaleController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['type-document-sale:read'])], document.getAll);
        router.get('/status', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['type-document-sale:read-status'])], document.getStatus);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['type-document-sale:update-status'])], document.status);

        return router;
    }
}
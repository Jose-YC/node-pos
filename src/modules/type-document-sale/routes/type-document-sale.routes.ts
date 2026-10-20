import { Router } from "express";
import { TypeDocumentSaleController } from "../controller/type-document-sale.controller";
import { AuthMiddleware } from '../../../middlewares';

export class TypeDocumentSaleRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const document = new TypeDocumentSaleController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['type-document-sale:read'])], document.get);
        router.get('/options', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['type-document-sale:options'])], document.options);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['type-document-sale:update-status'])], document.status);

        return router;
    }
}
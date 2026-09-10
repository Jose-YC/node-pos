import { Router } from "express";
import { IdentityDocumentTypeController } from "../controller/identity-document-type.controller";
import { AuthMiddleware } from '../../../middlewares';

export class IdentityDocumentTypeRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const identity = new IdentityDocumentTypeController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['identity-document-type:read'])], identity.get);

        return router;
    }
}
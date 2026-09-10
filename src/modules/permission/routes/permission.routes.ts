import { Router } from "express";
import { PermissionController } from "../controller/permission.controller";
import { AuthMiddleware } from '../../../middlewares';

export class PermissionRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const permission= new PermissionController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['permissions:read'])], permission.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['permissions:byid'])], permission.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['permissions:create'])], permission.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['permissions:update'])], permission.put);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['permissions:delete'])], permission.delete);
        
        return router;
    }
}
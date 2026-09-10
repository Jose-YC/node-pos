import { Router } from "express";
import { RoleController } from "../controller/rol.controller";
import { AuthMiddleware } from '../../../middlewares';


export class RoleRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const rol= new RoleController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['roles:read'])], rol.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['roles:byid'])], rol.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['roles:create'])], rol.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['roles:update'])], rol.put);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['roles:delete'])], rol.delete);
        
        return router;
    }
}
import { Router } from "express";

import { UserController } from "../controller/user.controller";
import { AuthMiddleware } from '../../../middlewares';


export class UserRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const user = new UserController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['users:read'])], user.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['users:byid'])], user.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['users:create'])], user.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['users:update'])], user.put);
        router.delete('delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['users:delete'])], user.delete);
        
        // Rutas para el perfil del usuario autenticado
        router.patch('/profile', [authMiddleware.validateJWT], user.profile);
        router.patch('/password', [authMiddleware.validateJWT], user.password);
        router.patch('/image', [authMiddleware.validateJWT], user.image);

        return router;
    }
}
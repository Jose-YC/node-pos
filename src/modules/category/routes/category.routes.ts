import { Router } from "express";
import { CategoryController } from "../controller/category.controller";
import { AuthMiddleware } from '../../../middlewares';

export class CategoryRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const category= new CategoryController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['categories:read'])], category.get);
        router.get('/options', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['categories:options'])], category.options);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['categories:byid'])], category.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['categories:create'])], category.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['categories:update'])], category.put);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['categories:delete'])], category.delete);
        
        return router;
    }
}
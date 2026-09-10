import { Router } from "express";
import { ProductController } from "../controller/product.controller";
import { AuthMiddleware } from '../../../middlewares';

export class ProductRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const product= new ProductController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:read'])], product.get);
        router.get('/catalog', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:read-catalog'])], product.getCatalog);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:byid'])], product.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:create'])], product.post);
        router.patch('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:update'])], product.put);
        router.patch('/image/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:update'])], product.image);
        router.patch('/status/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:status'])], product.status);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['products:delete'])], product.delete);
        
        return router;
    }
}
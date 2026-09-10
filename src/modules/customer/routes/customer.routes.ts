import { Router } from "express";
import { CustomerController } from "../controller/customer.controller";
import { AuthMiddleware } from '../../../middlewares';

export class CustomerRoutes {

    static get routes():Router{
        const router = Router();
        // controlador  
        const customer= new CustomerController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['customers:read'])], customer.get);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['customers:byid'])], customer.getId);
        router.post('/create', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['customers:create'])], customer.post);
        router.put('/update/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['customers:update'])], customer.put);
        router.delete('/delete/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['customers:delete'])], customer.delete);
        
        return router;
    }
}
import { Router } from "express";
import { BoxOpenController } from "../controller/box-open.controller";
import { AuthMiddleware } from '../../../middlewares';


export class BoxOpenRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const box= new BoxOpenController();
        const authMiddleware = new AuthMiddleware();

        router.get('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['box-open:read'])], box.get);
        router.post('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['box-open:create'])], box.open);

        return router;
    }
}
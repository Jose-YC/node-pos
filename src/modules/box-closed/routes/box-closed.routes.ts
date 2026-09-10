import { Router } from "express";
import { BoxClosedController } from "../controller/box-closed.controller";
import { AuthMiddleware } from '../../../middlewares';


export class BoxClosedRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const closed = new BoxClosedController();
        const authMiddleware = new AuthMiddleware();

        router.post('/', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['box-closed:create'])], closed.closed);
        router.get('/:id', [authMiddleware.validateJWT, authMiddleware.validatePermissions(['box-closed:byid'])], closed.getId);
        
        return router;
    }
}
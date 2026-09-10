import { Router } from "express";
import { ImageController } from "../controller/image.controller";
import { AuthMiddleware } from '../../../middlewares';


export class ImageRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const image = new ImageController();
        const authMiddleware = new AuthMiddleware();

        router.post('/', [authMiddleware.validateJWT], image.upload);
       
        return router;
    }
}
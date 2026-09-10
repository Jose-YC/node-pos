import { Router } from "express";
import { AuthController } from "../controller/auth.controller";

export class AuthRoutes {

    static get routes():Router{
        const router = Router();
        // controlador
        const rol= new AuthController();

        router.post('/login', rol.login);
        router.post('/register', rol.register);
        router.get('/refresh', rol.refresh);

        return router;
    }
}
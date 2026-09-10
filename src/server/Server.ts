import express, { Router } from 'express';
import swaggerUi from "swagger-ui-express";
import cors from 'cors';

import { Server as HttpServer } from 'http';
import { errorMiddleware } from '../middlewares';
import { swagger } from '../config';

interface Options {
    port: number;
    routes: Router;
}

export class Server {

    private readonly app = express();
    private readonly port : number;
    private readonly routes : Router;
    private server?: HttpServer;

    constructor (options: Options) {
        this.port = options.port;
        this.routes = options.routes;
        this.configure();
    }

    private configure() {
        this.app.use(cors())
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));

        this.app.use(
            '/doc',
            swaggerUi.serve,
            swaggerUi.setup(swagger, {
                swaggerOptions: {
                    persistAuthorization: true,
                },
            }),
        );
        
        this.app.use('/', this.routes);
        this.app.use(errorMiddleware);
    }
    
    async start(): Promise<void> {
        return new Promise((resolve) => {
            this.server = this.app.listen(this.port, () => {
                console.log(`Server running on port ${this.port}`);
                resolve();
            });
        });
    };

    public getApp(): express.Application {
        return this.app;
    };

    public close() {
      this.server?.close();
    };
    

}
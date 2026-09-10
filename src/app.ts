
import { env } from './config';
import { AppRoutes } from './server/routes';
import { Server } from './server/Server';

const main = async () => {
    const server = new Server(
        {
            port: env.PORT,
            routes: AppRoutes.routes
        }
    );

    return await server.start();
}


(() => {
    main();
})();
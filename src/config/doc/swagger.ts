import swaggerJsdoc from 'swagger-jsdoc';

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'RBAC API',
      version: '1.0.0',
      description: 'Documentación generada con Swagger',
    },
    servers: [{ url: 'http://localhost:3000' }],
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ['./src/doc/**/*.yml'],
};

export const swagger = swaggerJsdoc(options);
INSERT INTO "reason" (name, description, status, updated_at) VALUES
('EXPIRY',    'Vencimiento del producto',                     'OUT', NOW()),
('DAMAGE',    'Rotura, humedad o deterioro del producto',     'OUT', NOW()),
('THEFT',     'Robo comprobado',                              'OUT', NOW()),
('TRANSPORT', 'Daño en transporte o manipulación',            'OUT', NOW()),
('PEST',      'Plaga o contaminación',                        'OUT', NOW()),
('OTHER',     'Otros motivos de salida',                      'OUT', NOW()),

('COUNT_ERROR','Error de conteo previo',                      'IN', NOW()),
('FOUND',      'Producto encontrado sin registro previo',     'IN', NOW()),
('DAMAGE',     'Daño puntual sin documento de merma',         'IN', NOW()),
('CORRECTION', 'Corrección de error de captura',              'IN', NOW()),
('OTHER',      'Otros motivos de entrada',                    'IN', NOW());
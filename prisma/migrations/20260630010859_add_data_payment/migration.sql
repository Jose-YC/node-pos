INSERT INTO payment (name, type, updated_at)
VALUES
    ('Efectivo',            'cash', NOW()),
    ('Tarjeta de Crédito',  'bank', NOW()),
    ('Yape',                'digital_wallet', NOW()),
    ('Plin',                'digital_wallet', NOW());
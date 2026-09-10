INSERT INTO payment (name, type, updated_at)
VALUES
    ('Efectivo',            'cash', NOW()),
    ('Tarjeta de Crédito',  'card', NOW()),
    ('Yape',                'digital_wallet', NOW()),
    ('Plin',                'digital_wallet', NOW())
ON CONFLICT (type) DO NOTHING;
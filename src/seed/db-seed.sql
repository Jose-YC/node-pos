-- =============================================================================
-- db-seed.sql  |  Seed DETERMINISTA – Tienda Cosméticos Perú
-- 30 cierres de caja × 30 ventas | IGV 18% | Alineado al schema actual
-- =============================================================================
-- PRE-REQUISITOS (deben existir):
--   identity_document_type, permission, payment, type_document_sale, reason,
--   customer genérico (is_generic = true)
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- 1. ROLES
-- -----------------------------------------------------------------------------
INSERT INTO "role" ("name", "description", "created_at", "updated_at")
SELECT v.name, v.description, NOW(), NOW()
FROM (VALUES
  ('Administrador', 'Acceso total al sistema'),
  ('Cajero', 'Operaciones de caja y ventas'),
  ('Supervisor', 'Supervisión y reportes')
) AS v(name, description)
WHERE NOT EXISTS (SELECT 1 FROM "role" r WHERE r.name = v.name AND r.deleted_at IS NULL);

-- -----------------------------------------------------------------------------
-- 2. USUARIOS  (password = "password")
-- -----------------------------------------------------------------------------
INSERT INTO "user" ("name", "email", "password", "image_url", "created_at", "updated_at")
VALUES
  ('Admin Principal', 'carlos.mendoza@tienda.com', '$2b$10$JY7lfTBBJsr3QIEuot1Wo.E2l/NUYlg7drTeWXAyak.94i9ZYE6RG', NULL, NOW(), NOW()),
  ('Cajero Uno',      'caja1@tienda.com', '$2b$10$JY7lfTBBJsr3QIEuot1Wo.E2l/NUYlg7drTeWXAyak.94i9ZYE6RG', NULL, NOW(), NOW()),
  ('Cajero Dos',      'caja2@tienda.com', '$2b$10$JY7lfTBBJsr3QIEuot1Wo.E2l/NUYlg7drTeWXAyak.94i9ZYE6RG', NULL, NOW(), NOW()),
  ('Supervisor',      'supervisor@tienda.com', '$2b$10$JY7lfTBBJsr3QIEuot1Wo.E2l/NUYlg7drTeWXAyak.94i9ZYE6RG', NULL, NOW(), NOW())
ON CONFLICT ("email") DO UPDATE SET
  name = EXCLUDED.name,
  password = EXCLUDED.password,
  updated_at = NOW();

-- -----------------------------------------------------------------------------
-- 3. USER_ROLE
-- -----------------------------------------------------------------------------
INSERT INTO "user_role" ("user_id", "role_id", "created_at")
SELECT u.id, r.id, NOW()
FROM "user" u
CROSS JOIN "role" r
WHERE (u.email = 'carlos.mendoza@tienda.com' AND r.name = 'Administrador')
   OR (u.email = 'caja1@tienda.com' AND r.name = 'Cajero')
   OR (u.email = 'caja2@tienda.com' AND r.name = 'Cajero')
   OR (u.email = 'supervisor@tienda.com' AND r.name = 'Supervisor')
ON CONFLICT (user_id, role_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 4. ROLE_PERMISSION – Administrador (todos)
-- -----------------------------------------------------------------------------
INSERT INTO "role_permission" ("role_id", "permission_id", "created_at")
SELECT r.id, p.id, NOW()
FROM "role" r
CROSS JOIN "permission" p
WHERE r.name = 'Administrador'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 5. ROLE_PERMISSION – Cajero
-- -----------------------------------------------------------------------------
INSERT INTO "role_permission" ("role_id", "permission_id", "created_at")
SELECT r.id, p.id, NOW()
FROM "role" r
CROSS JOIN "permission" p
WHERE r.name = 'Cajero'
  AND p.name IN (
    'sale:create', 'sale:byid', 'sale:readid', 'sale:read',
    'credit-note:create',
    'box-open:create', 'box-closed:create', 'box-closed:byid',
    'customers:create', 'customers:read', 'customers:byid',
    'products:read', 'products:read-catalog', 'products:byid',
    'payments:read',
    'type-document-sale:read', 'type-document-sale:read-status',
    'identity-document-type:read'
  )
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- -----------------------------------------------------------------------------
-- 6. CATEGORÍAS
-- -----------------------------------------------------------------------------
INSERT INTO "category" ("name", "description", "created_at")
SELECT v.name, v.description, NOW()
FROM (VALUES
  ('Cuidado Facial', 'Cremas, serums, limpiadores y tratamientos faciales'),
  ('Labiales y Maquillaje', 'Labiales, bases, sombras y correctores'),
  ('Perfumería', 'Fragancias y colonias para dama y caballero'),
  ('Cuidado Capilar', 'Shampoo, acondicionador, tratamientos y aceites'),
  ('Cuidado Corporal', 'Cremas corporales, exfoliantes y aceites'),
  ('Accesorios de Belleza', 'Brochas, esponjas, espejos y herramientas')
) AS v(name, description)
WHERE NOT EXISTS (
  SELECT 1 FROM "category" c WHERE c.name = v.name AND c.deleted_at IS NULL
);

-- -----------------------------------------------------------------------------
-- 7. PRODUCTOS + PRECIOS + STOCK
-- -----------------------------------------------------------------------------
WITH cats AS (
  SELECT id, name FROM "category" WHERE deleted_at IS NULL
),
prod_data AS (
  SELECT * FROM (VALUES
    ('FAC-001', 'Serum Vitamina C 30ml', 'Serum antioxidante con vitamina C pura', 'Cuidado Facial', 8, 28.50, 59.90, 450),
    ('FAC-002', 'Crema Hidratante Día 50ml', 'Hidratante facial con ácido hialurónico', 'Cuidado Facial', 10, 22.00, 49.90, 500),
    ('FAC-003', 'Limpiador Facial Gel 150ml', 'Gel limpiador suave para todo tipo de piel', 'Cuidado Facial', 12, 15.50, 34.90, 480),
    ('FAC-004', 'Mascarilla de Arcilla 100g', 'Mascarilla purificante de arcilla verde', 'Cuidado Facial', 6, 18.00, 39.90, 350),
    ('FAC-005', 'Contorno de Ojos 15ml', 'Contorno de ojos anti-ojeras y bolsas', 'Cuidado Facial', 5, 25.00, 54.90, 300),
    ('LAB-001', 'Labial Mate Rojo Intenso', 'Labial de larga duración tono rojo', 'Labiales y Maquillaje', 15, 12.00, 29.90, 600),
    ('LAB-002', 'Labial Nude Satinado', 'Labial satinado tono nude', 'Labiales y Maquillaje', 15, 12.00, 29.90, 580),
    ('LAB-003', 'Base Líquida SPF15 30ml', 'Base de cobertura media con protección solar', 'Labiales y Maquillaje', 8, 32.00, 69.90, 400),
    ('LAB-004', 'Paleta Sombras 12 tonos', 'Paleta de sombras neutras y tierra', 'Labiales y Maquillaje', 6, 35.00, 79.90, 320),
    ('LAB-005', 'Rímel Volumen Extra', 'Rímel para pestañas volumen y longitud', 'Labiales y Maquillaje', 12, 16.50, 36.90, 450),
    ('PER-001', 'Eau de Parfum Floral 50ml', 'Fragancia floral fresca para dama', 'Perfumería', 5, 48.00, 119.90, 280),
    ('PER-002', 'Colonia Cítrica Hombre 100ml', 'Colonia fresca cítrica para caballero', 'Perfumería', 5, 42.00, 99.90, 260),
    ('PER-003', 'Body Mist Vainilla 200ml', 'Body mist suave aroma vainilla', 'Perfumería', 8, 18.00, 44.90, 380),
    ('CAP-001', 'Shampoo Reparador 400ml', 'Shampoo para cabello dañado y teñido', 'Cuidado Capilar', 10, 14.00, 32.90, 420),
    ('CAP-002', 'Acondicionador Keratina 400ml', 'Acondicionador con keratina hidrolizada', 'Cuidado Capilar', 10, 15.00, 34.90, 400),
    ('CAP-003', 'Aceite Capilar Argán 50ml', 'Aceite de argán puro para puntas', 'Cuidado Capilar', 6, 22.00, 49.90, 300),
    ('COR-001', 'Crema Corporal Coco 250ml', 'Crema hidratante corporal aroma coco', 'Cuidado Corporal', 10, 16.00, 37.90, 380),
    ('COR-002', 'Exfoliante Corporal Azúcar 200g', 'Exfoliante natural de azúcar y manteca', 'Cuidado Corporal', 7, 19.00, 42.90, 320),
    ('COR-003', 'Aceite Corporal Almendra 100ml', 'Aceite de almendras dulces hidratante', 'Cuidado Corporal', 6, 17.50, 39.90, 280),
    ('ACC-001', 'Set Brochas Maquillaje 8 pzs', 'Set profesional de brochas sintéticas', 'Accesorios de Belleza', 5, 28.00, 64.90, 250),
    ('ACC-002', 'Esponja Beauty Blender', 'Esponja de maquillaje hipoalergénica', 'Accesorios de Belleza', 12, 8.00, 19.90, 500),
    ('ACC-003', 'Espejo LED Portátil', 'Espejo de aumento con luz LED', 'Accesorios de Belleza', 4, 35.00, 79.90, 200),
    ('FAC-999', 'Serum Retinol Premium 30ml', 'Serum de retinol de alta concentración', 'Cuidado Facial', 3, 55.00, 149.90, 40),
    ('PER-999', 'Perfume Niché Oud 50ml', 'Fragancia niché de oud oriental', 'Perfumería', 2, 95.00, 249.90, 25),
    ('ACC-999', 'Kit Profesionales Makeup', 'Kit completo para maquilladores', 'Accesorios de Belleza', 2, 120.00, 299.90, 20)
  ) AS t(sku, name, description, category_name, min_stock, cost, price, initial_stock)
)
INSERT INTO "product" (
  "sku", "name", "description", "image", "min_order_qty", "min_stock",
  "status", "category_id", "created_at", "updated_at"
)
SELECT
  pd.sku, pd.name, pd.description,
  'https://cdn.belleza.pe/products/' || lower(pd.sku) || '.jpg',
  1, pd.min_stock, true, c.id, NOW(), NOW()
FROM prod_data pd
JOIN cats c ON c.name = pd.category_name
WHERE NOT EXISTS (SELECT 1 FROM "product" p WHERE p.sku = pd.sku AND p.deleted_at IS NULL);

-- Precios VENTA
INSERT INTO "product_price" (
  "product_id", "product_name", "product_description",
  "buying", "selling", "amount", "created_at", "updated_at"
)
SELECT p.id, p.name, p.description, false, true, pd.price, NOW(), NOW()
FROM "product" p
JOIN (VALUES
  ('FAC-001', 59.90), ('FAC-002', 49.90), ('FAC-003', 34.90), ('FAC-004', 39.90), ('FAC-005', 54.90),
  ('LAB-001', 29.90), ('LAB-002', 29.90), ('LAB-003', 69.90), ('LAB-004', 79.90), ('LAB-005', 36.90),
  ('PER-001', 119.90), ('PER-002', 99.90), ('PER-003', 44.90),
  ('CAP-001', 32.90), ('CAP-002', 34.90), ('CAP-003', 49.90),
  ('COR-001', 37.90), ('COR-002', 42.90), ('COR-003', 39.90),
  ('ACC-001', 64.90), ('ACC-002', 19.90), ('ACC-003', 79.90),
  ('FAC-999', 149.90), ('PER-999', 249.90), ('ACC-999', 299.90)
) AS pd(sku, price) ON p.sku = pd.sku
WHERE NOT EXISTS (
  SELECT 1 FROM "product_price" pp
  WHERE pp.product_id = p.id AND pp.selling = true AND pp.deleted_at IS NULL
);

-- Precios COMPRA
INSERT INTO "product_price" (
  "product_id", "product_name", "product_description",
  "buying", "selling", "amount", "created_at", "updated_at"
)
SELECT p.id, p.name, p.description, true, false, pd.cost, NOW(), NOW()
FROM "product" p
JOIN (VALUES
  ('FAC-001', 28.50), ('FAC-002', 22.00), ('FAC-003', 15.50), ('FAC-004', 18.00), ('FAC-005', 25.00),
  ('LAB-001', 12.00), ('LAB-002', 12.00), ('LAB-003', 32.00), ('LAB-004', 35.00), ('LAB-005', 16.50),
  ('PER-001', 48.00), ('PER-002', 42.00), ('PER-003', 18.00),
  ('CAP-001', 14.00), ('CAP-002', 15.00), ('CAP-003', 22.00),
  ('COR-001', 16.00), ('COR-002', 19.00), ('COR-003', 17.50),
  ('ACC-001', 28.00), ('ACC-002', 8.00), ('ACC-003', 35.00),
  ('FAC-999', 55.00), ('PER-999', 95.00), ('ACC-999', 120.00)
) AS pd(sku, cost) ON p.sku = pd.sku
WHERE NOT EXISTS (
  SELECT 1 FROM "product_price" pp
  WHERE pp.product_id = p.id AND pp.buying = true AND pp.deleted_at IS NULL
);

-- Stock inicial
INSERT INTO "product_stock" (
  "product_id", "stock", "valuation_rate", "stock_value", "created_at", "updated_at"
)
SELECT p.id, pd.initial_stock, pd.cost, ROUND(pd.cost * pd.initial_stock, 2), NOW(), NOW()
FROM "product" p
JOIN (VALUES
  ('FAC-001', 28.50, 450), ('FAC-002', 22.00, 500), ('FAC-003', 15.50, 480), ('FAC-004', 18.00, 350), ('FAC-005', 25.00, 300),
  ('LAB-001', 12.00, 600), ('LAB-002', 12.00, 580), ('LAB-003', 32.00, 400), ('LAB-004', 35.00, 320), ('LAB-005', 16.50, 450),
  ('PER-001', 48.00, 280), ('PER-002', 42.00, 260), ('PER-003', 18.00, 380),
  ('CAP-001', 14.00, 420), ('CAP-002', 15.00, 400), ('CAP-003', 22.00, 300),
  ('COR-001', 16.00, 380), ('COR-002', 19.00, 320), ('COR-003', 17.50, 280),
  ('ACC-001', 28.00, 250), ('ACC-002', 8.00, 500), ('ACC-003', 35.00, 200),
  ('FAC-999', 55.00, 40), ('PER-999', 95.00, 25), ('ACC-999', 120.00, 20)
) AS pd(sku, cost, initial_stock) ON p.sku = pd.sku
WHERE NOT EXISTS (
  SELECT 1 FROM "product_stock" ps WHERE ps.product_id = p.id AND ps.deleted_at IS NULL
);

-- -----------------------------------------------------------------------------
-- 8. CLIENTES
-- -----------------------------------------------------------------------------
INSERT INTO "customer" (
  "doc_type_code", "doc_type_name", "doc_type_number", "name",
  "is_generic", "email", "phone", "created_at", "updated_at"
)
SELECT v.doc_type_code, v.doc_type_name, v.doc_type_number, v.name,
       false, v.email, v.phone, NOW(), NOW()
FROM (VALUES
  ('01', 'DNI', '45678912', 'María Elena Quispe Rojas', 'maria.quispe@email.com', '987654321'),
  ('01', 'DNI', '72345678', 'Carlos Alberto Mendoza Silva', 'carlos.mendoza@email.com', '976543210'),
  ('01', 'DNI', '51234567', 'Ana Lucía Vargas Torres', 'ana.vargas@email.com', '965432109'),
  ('01', 'DNI', '63456789', 'José Luis Ramírez Castro', 'jose.ramirez@email.com', '954321098'),
  ('01', 'DNI', '44567890', 'Rosa María Flores Huamán', 'rosa.flores@email.com', '943210987'),
  ('06', 'RUC', '20123456789', 'Belleza Integral SAC', 'compras@bellezaintegral.pe', '014567890'),
  ('06', 'RUC', '20567890123', 'Spa Relax Perú EIRL', 'admin@sparelax.pe', '015678901'),
  ('01', 'DNI', '56789012', 'Pedro Pablo Gutiérrez León', 'pedro.gutierrez@email.com', '932109876'),
  ('01', 'DNI', '67890123', 'Lucía Fernanda Paredes Díaz', 'lucia.paredes@email.com', '921098765'),
  ('01', 'DNI', '78901234', 'Miguel Ángel Soto Chávez', 'miguel.soto@email.com', '910987654')
) AS v(doc_type_code, doc_type_name, doc_type_number, name, email, phone)
WHERE NOT EXISTS (
  SELECT 1 FROM "customer" c WHERE c.doc_type_number = v.doc_type_number
);

-- -----------------------------------------------------------------------------
-- 9. CAJAS ABIERTAS (30)
-- -----------------------------------------------------------------------------
INSERT INTO "box_open" ("serie", "user_id", "start_date", "end_date", "status", "notes", "created_at", "updated_at")
SELECT v.serie, u.id, v.start_date::timestamptz, NULL, 'abierto', v.notes, NOW(), NOW()
FROM (VALUES
  ('CAJ-000001', 'caja1@tienda.com', '2025-08-01 08:00:00+00', 'Turno 1'),
  ('CAJ-000002', 'caja2@tienda.com', '2025-08-01 14:00:00+00', 'Turno 2'),
  ('CAJ-000003', 'caja1@tienda.com', '2025-08-02 08:00:00+00', 'Turno 3'),
  ('CAJ-000004', 'caja2@tienda.com', '2025-08-02 14:00:00+00', 'Turno 4'),
  ('CAJ-000005', 'caja1@tienda.com', '2025-08-03 08:00:00+00', 'Turno 5'),
  ('CAJ-000006', 'caja2@tienda.com', '2025-08-03 14:00:00+00', 'Turno 6'),
  ('CAJ-000007', 'caja1@tienda.com', '2025-08-04 08:00:00+00', 'Turno 7'),
  ('CAJ-000008', 'caja2@tienda.com', '2025-08-04 14:00:00+00', 'Turno 8'),
  ('CAJ-000009', 'caja1@tienda.com', '2025-08-05 08:00:00+00', 'Turno 9'),
  ('CAJ-000010', 'caja2@tienda.com', '2025-08-05 14:00:00+00', 'Turno 10'),
  ('CAJ-000011', 'caja1@tienda.com', '2025-08-06 08:00:00+00', 'Turno 11'),
  ('CAJ-000012', 'caja2@tienda.com', '2025-08-06 14:00:00+00', 'Turno 12'),
  ('CAJ-000013', 'caja1@tienda.com', '2025-08-07 08:00:00+00', 'Turno 13'),
  ('CAJ-000014', 'caja2@tienda.com', '2025-08-07 14:00:00+00', 'Turno 14'),
  ('CAJ-000015', 'caja1@tienda.com', '2025-08-08 08:00:00+00', 'Turno 15'),
  ('CAJ-000016', 'caja2@tienda.com', '2025-08-08 14:00:00+00', 'Turno 16'),
  ('CAJ-000017', 'caja1@tienda.com', '2025-08-09 08:00:00+00', 'Turno 17'),
  ('CAJ-000018', 'caja2@tienda.com', '2025-08-09 14:00:00+00', 'Turno 18'),
  ('CAJ-000019', 'caja1@tienda.com', '2025-08-10 08:00:00+00', 'Turno 19'),
  ('CAJ-000020', 'caja2@tienda.com', '2025-08-10 14:00:00+00', 'Turno 20'),
  ('CAJ-000021', 'caja1@tienda.com', '2025-08-11 08:00:00+00', 'Turno 21'),
  ('CAJ-000022', 'caja2@tienda.com', '2025-08-11 14:00:00+00', 'Turno 22'),
  ('CAJ-000023', 'caja1@tienda.com', '2025-08-12 08:00:00+00', 'Turno 23'),
  ('CAJ-000024', 'caja2@tienda.com', '2025-08-12 14:00:00+00', 'Turno 24'),
  ('CAJ-000025', 'caja1@tienda.com', '2025-08-13 08:00:00+00', 'Turno 25'),
  ('CAJ-000026', 'caja2@tienda.com', '2025-08-13 14:00:00+00', 'Turno 26'),
  ('CAJ-000027', 'caja1@tienda.com', '2025-08-14 08:00:00+00', 'Turno 27'),
  ('CAJ-000028', 'caja2@tienda.com', '2025-08-14 14:00:00+00', 'Turno 28'),
  ('CAJ-000029', 'caja1@tienda.com', '2025-08-15 08:00:00+00', 'Turno 29'),
  ('CAJ-000030', 'caja2@tienda.com', '2025-08-15 14:00:00+00', 'Turno 30')
) AS v(serie, email, start_date, notes)
JOIN "user" u ON u.email = v.email
WHERE NOT EXISTS (SELECT 1 FROM "box_open" b WHERE b.serie = v.serie);

INSERT INTO "detail_box_open" ("box_open_id", "mode_payment", "opening_amount", "created_at", "updated_at")
SELECT b.id, pay.id, v.opening_amount, NOW(), NOW()
FROM (VALUES
  ('CAJ-000001', 200.00), ('CAJ-000002', 250.00), ('CAJ-000003', 180.00),
  ('CAJ-000004', 300.00), ('CAJ-000005', 220.00), ('CAJ-000006', 200.00),
  ('CAJ-000007', 280.00), ('CAJ-000008', 150.00), ('CAJ-000009', 250.00),
  ('CAJ-000010', 200.00), ('CAJ-000011', 300.00), ('CAJ-000012', 180.00),
  ('CAJ-000013', 220.00), ('CAJ-000014', 260.00), ('CAJ-000015', 190.00),
  ('CAJ-000016', 240.00), ('CAJ-000017', 210.00), ('CAJ-000018', 270.00),
  ('CAJ-000019', 200.00), ('CAJ-000020', 230.00), ('CAJ-000021', 250.00),
  ('CAJ-000022', 180.00), ('CAJ-000023', 300.00), ('CAJ-000024', 220.00),
  ('CAJ-000025', 190.00), ('CAJ-000026', 280.00), ('CAJ-000027', 210.00),
  ('CAJ-000028', 240.00), ('CAJ-000029', 200.00), ('CAJ-000030', 260.00)
) AS v(serie, opening_amount)
JOIN "box_open" b ON b.serie = v.serie
JOIN "payment" pay ON pay.type = 'cash' AND pay.deleted_at IS NULL
WHERE NOT EXISTS (SELECT 1 FROM "detail_box_open" d WHERE d.box_open_id = b.id);

-- -----------------------------------------------------------------------------
-- 10. VENTAS (30 por caja) + DETALLE + PAGO + KARDEX
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  r_box RECORD;
  v_sale_id INT;
  v_serie TEXT;
  v_type_code TEXT;
  v_customer_id INT;
  v_customer_name TEXT;
  v_customer_doc_code TEXT;
  v_customer_doc_number TEXT;
  v_taxable NUMERIC(12,2);
  v_igv NUMERIC(12,2);
  v_total NUMERIC(12,2);
  v_paid NUMERIC(12,2);
  v_change NUMERIC(12,2);
  v_payment_id INT;
  v_payment_name TEXT;
  v_sale_date TIMESTAMPTZ;
  v_product_id INT;
  v_product_name TEXT;
  v_qty INT;
  v_price NUMERIC(12,2);
  v_subtotal NUMERIC(12,2);
  v_stock_before INT;
  v_stock_after INT;
  v_valuation NUMERIC(12,2);
  v_boleta_n INT := 1;
  v_factura_n INT := 1;
  v_shift_idx INT;
  v_sale_idx INT;
  v_pay_type INT;
  v_is_invoice BOOLEAN;
  v_generic_id INT;
  v_user_id INT;
  prod_skus TEXT[] := ARRAY[
    'FAC-001','FAC-002','FAC-003','FAC-004','FAC-005',
    'LAB-001','LAB-002','LAB-003','LAB-004','LAB-005',
    'PER-001','PER-002','PER-003',
    'CAP-001','CAP-002','CAP-003',
    'COR-001','COR-002','COR-003',
    'ACC-001','ACC-002','ACC-003'
  ];
BEGIN
  SELECT id INTO v_generic_id FROM "customer" WHERE is_generic = true LIMIT 1;

  FOR r_box IN
    SELECT b.id AS box_id, b.serie, b.user_id, b.start_date,
           (ROW_NUMBER() OVER (ORDER BY b.serie) - 1)::INT AS shift_idx
    FROM "box_open" b
    WHERE b.serie LIKE 'CAJ-%'
    ORDER BY b.serie
  LOOP
    v_shift_idx := r_box.shift_idx;
    v_user_id := r_box.user_id;

    FOR v_sale_idx IN 0..29 LOOP
      v_is_invoice := (v_sale_idx % 7 = 0);
      IF v_is_invoice THEN
        v_type_code := '01';
        v_serie := 'F001-' || LPAD(v_factura_n::TEXT, 6, '0');
        v_factura_n := v_factura_n + 1;
      ELSE
        v_type_code := '03';
        v_serie := 'B001-' || LPAD(v_boleta_n::TEXT, 6, '0');
        v_boleta_n := v_boleta_n + 1;
      END IF;

      v_sale_date := r_box.start_date + (v_sale_idx * INTERVAL '10 minutes');

      IF v_is_invoice OR (v_sale_idx % 3 = 0) THEN
        SELECT id, name, doc_type_code, doc_type_number
        INTO v_customer_id, v_customer_name, v_customer_doc_code, v_customer_doc_number
        FROM "customer"
        WHERE is_generic = false AND deleted_at IS NULL
        ORDER BY id
        OFFSET ((v_shift_idx + v_sale_idx) % 10)
        LIMIT 1;
      ELSE
        v_customer_id := v_generic_id;
        v_customer_name := 'CLIENTES VARIOS';
        v_customer_doc_code := '01';
        v_customer_doc_number := '00000000';
      END IF;

      v_pay_type := (v_shift_idx + v_sale_idx) % 4;
      IF v_pay_type = 0 THEN
        SELECT id, name INTO v_payment_id, v_payment_name FROM "payment" WHERE type = 'cash' AND deleted_at IS NULL LIMIT 1;
      ELSIF v_pay_type = 1 THEN
        SELECT id, name INTO v_payment_id, v_payment_name FROM "payment" WHERE type = 'card' AND deleted_at IS NULL LIMIT 1;
      ELSIF v_pay_type = 2 THEN
        SELECT id, name INTO v_payment_id, v_payment_name FROM "payment" WHERE type = 'digital_wallet' AND name = 'Yape' AND deleted_at IS NULL LIMIT 1;
      ELSE
        SELECT id, name INTO v_payment_id, v_payment_name FROM "payment" WHERE type = 'digital_wallet' AND name = 'Plin' AND deleted_at IS NULL LIMIT 1;
      END IF;

      -- Total 2 líneas
      SELECT p.id, p.name, pp.amount INTO v_product_id, v_product_name, v_price
      FROM "product" p
      JOIN "product_price" pp ON pp.product_id = p.id AND pp.selling = true AND pp.deleted_at IS NULL
      WHERE p.sku = prod_skus[((v_shift_idx * 30 + v_sale_idx) % 22) + 1] LIMIT 1;
      v_qty := 1 + ((v_shift_idx + v_sale_idx) % 2);
      v_total := ROUND(v_price * v_qty, 2);

      SELECT p.id, p.name, pp.amount INTO v_product_id, v_product_name, v_price
      FROM "product" p
      JOIN "product_price" pp ON pp.product_id = p.id AND pp.selling = true AND pp.deleted_at IS NULL
      WHERE p.sku = prod_skus[(((v_shift_idx * 30 + v_sale_idx) + 7) % 22) + 1] LIMIT 1;
      v_total := v_total + ROUND(v_price * 1, 2);

      v_taxable := ROUND(v_total / 1.18, 2);
      v_igv := ROUND(v_total - v_taxable, 2);
      v_paid := v_total;
      v_change := 0;
      IF v_pay_type = 0 AND (v_sale_idx % 5 = 0) THEN
        v_paid := CEIL(v_total / 10.0) * 10;
        v_change := ROUND(v_paid - v_total, 2);
      END IF;

      INSERT INTO "sale" (
        "serie", "box_open_id", "type_code", "user_id", "sale_date",
        "customer_id", "customer_name", "customer_doc_code", "customer_doc_number",
        "igv_rate", "taxable_amount", "igv_total", "total",
        "paid_amount", "change_amount", "is_return", "return_against_id",
        "created_at", "updated_at"
      ) VALUES (
        v_serie, r_box.box_id, v_type_code, v_user_id, v_sale_date,
        v_customer_id, v_customer_name, v_customer_doc_code, v_customer_doc_number,
        0.18, v_taxable, v_igv, v_total, v_paid, v_change, false, NULL, NOW(), NOW()
      ) RETURNING id INTO v_sale_id;

      -- Línea 1
      SELECT p.id, p.name, pp.amount INTO v_product_id, v_product_name, v_price
      FROM "product" p
      JOIN "product_price" pp ON pp.product_id = p.id AND pp.selling = true AND pp.deleted_at IS NULL
      WHERE p.sku = prod_skus[((v_shift_idx * 30 + v_sale_idx) % 22) + 1] LIMIT 1;
      v_qty := 1 + ((v_shift_idx + v_sale_idx) % 2);
      v_subtotal := ROUND(v_price * v_qty, 2);

      INSERT INTO "detail_sale" ("sale_id","product_id","product_name","qty","price","subtotal","created_at","updated_at")
      VALUES (v_sale_id, v_product_id, v_product_name, v_qty, v_price, v_subtotal, NOW(), NOW());

      SELECT stock, valuation_rate INTO v_stock_before, v_valuation
      FROM "product_stock" WHERE product_id = v_product_id AND deleted_at IS NULL LIMIT 1;
      v_stock_after := GREATEST(0, v_stock_before - v_qty);

      INSERT INTO "kardex" (
        "kardex_date","product_id","type","doc_id","doc_type","doc_serie",
        "actual_qty","after_qty","incoming_rate","outgoing_rate",
        "valuation_rate","stock_value","created_at","updated_at"
      ) VALUES (
        v_sale_date::date, v_product_id, 'OUT', v_sale_id, 'venta', v_serie,
        v_stock_before, v_stock_after, 0, v_price,
        v_valuation, ROUND(v_valuation * v_stock_after, 2), NOW(), NOW()
      );
      UPDATE "product_stock"
      SET stock = v_stock_after, stock_value = ROUND(v_valuation * v_stock_after, 2), updated_at = NOW()
      WHERE product_id = v_product_id AND deleted_at IS NULL;

      -- Línea 2
      SELECT p.id, p.name, pp.amount INTO v_product_id, v_product_name, v_price
      FROM "product" p
      JOIN "product_price" pp ON pp.product_id = p.id AND pp.selling = true AND pp.deleted_at IS NULL
      WHERE p.sku = prod_skus[(((v_shift_idx * 30 + v_sale_idx) + 7) % 22) + 1] LIMIT 1;
      v_qty := 1;
      v_subtotal := ROUND(v_price * v_qty, 2);

      INSERT INTO "detail_sale" ("sale_id","product_id","product_name","qty","price","subtotal","created_at","updated_at")
      VALUES (v_sale_id, v_product_id, v_product_name, v_qty, v_price, v_subtotal, NOW(), NOW());

      SELECT stock, valuation_rate INTO v_stock_before, v_valuation
      FROM "product_stock" WHERE product_id = v_product_id AND deleted_at IS NULL LIMIT 1;
      v_stock_after := GREATEST(0, v_stock_before - v_qty);

      INSERT INTO "kardex" (
        "kardex_date","product_id","type","doc_id","doc_type","doc_serie",
        "actual_qty","after_qty","incoming_rate","outgoing_rate",
        "valuation_rate","stock_value","created_at","updated_at"
      ) VALUES (
        v_sale_date::date, v_product_id, 'OUT', v_sale_id, 'venta', v_serie,
        v_stock_before, v_stock_after, 0, v_price,
        v_valuation, ROUND(v_valuation * v_stock_after, 2), NOW(), NOW()
      );
      UPDATE "product_stock"
      SET stock = v_stock_after, stock_value = ROUND(v_valuation * v_stock_after, 2), updated_at = NOW()
      WHERE product_id = v_product_id AND deleted_at IS NULL;

      INSERT INTO "sale_payment" ("sale_id","box_open_id","payment_id","payment_name","amount","created_at","updated_at")
      VALUES (v_sale_id, r_box.box_id, v_payment_id, v_payment_name, v_total, NOW(), NOW());
    END LOOP;
  END LOOP;
END $$;

-- -----------------------------------------------------------------------------
-- 11. NOTAS DE CRÉDITO
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  r_sale RECORD;
  v_nc_id INT;
  v_nc_serie TEXT;
  v_nc_n INT := 1;
  v_return_total NUMERIC(12,2);
  v_taxable NUMERIC(12,2);
  v_igv NUMERIC(12,2);
  v_product_id INT;
  v_product_name TEXT;
  v_qty INT;
  v_price NUMERIC(12,2);
  v_subtotal NUMERIC(12,2);
  v_stock_before INT;
  v_stock_after INT;
  v_valuation NUMERIC(12,2);
  v_nc_date TIMESTAMPTZ;
  v_user_id INT;
  v_payment_id INT;
  v_payment_name TEXT;
  v_series TEXT[] := ARRAY['B001-000004','B001-000035','B001-000067','B001-000100','B001-000150','B001-000200','B001-000250','B001-000300'];
  v_s TEXT;
BEGIN
  SELECT id INTO v_user_id FROM "user" WHERE email = 'caja1@tienda.com' LIMIT 1;

  FOREACH v_s IN ARRAY v_series LOOP
    SELECT s.* INTO r_sale FROM "sale" s WHERE s.serie = v_s AND s.is_return = false LIMIT 1;
    IF NOT FOUND THEN CONTINUE; END IF;

    SELECT ds.product_id, ds.product_name, ds.price, 1
    INTO v_product_id, v_product_name, v_price, v_qty
    FROM "detail_sale" ds WHERE ds.sale_id = r_sale.id ORDER BY ds.id LIMIT 1;
    IF NOT FOUND THEN CONTINUE; END IF;

    v_subtotal := ROUND(v_price * v_qty, 2);
    v_return_total := v_subtotal;
    v_taxable := ROUND(v_return_total / 1.18, 2);
    v_igv := ROUND(v_return_total - v_taxable, 2);
    v_nc_serie := 'NC001-' || LPAD(v_nc_n::TEXT, 6, '0');
    v_nc_n := v_nc_n + 1;
    v_nc_date := r_sale.sale_date + INTERVAL '2 hours';

    SELECT payment_id, payment_name INTO v_payment_id, v_payment_name
    FROM "sale_payment" WHERE sale_id = r_sale.id LIMIT 1;

    INSERT INTO "sale" (
      "serie","box_open_id","type_code","user_id","sale_date",
      "customer_id","customer_name","customer_doc_code","customer_doc_number",
      "igv_rate","taxable_amount","igv_total","total",
      "paid_amount","change_amount","is_return","return_against_id",
      "created_at","updated_at"
    ) VALUES (
      v_nc_serie, r_sale.box_open_id, '07', v_user_id, v_nc_date,
      r_sale.customer_id, r_sale.customer_name, r_sale.customer_doc_code, r_sale.customer_doc_number,
      0.18, v_taxable, v_igv, v_return_total, v_return_total, 0, true, r_sale.id, NOW(), NOW()
    ) RETURNING id INTO v_nc_id;

    INSERT INTO "detail_sale" ("sale_id","product_id","product_name","qty","price","subtotal","created_at","updated_at")
    VALUES (v_nc_id, v_product_id, v_product_name, v_qty, v_price, v_subtotal, NOW(), NOW());

    INSERT INTO "sale_payment" ("sale_id","box_open_id","payment_id","payment_name","amount","created_at","updated_at")
    VALUES (v_nc_id, r_sale.box_open_id, v_payment_id, v_payment_name, -v_return_total, NOW(), NOW());

    SELECT stock, valuation_rate INTO v_stock_before, v_valuation
    FROM "product_stock" WHERE product_id = v_product_id AND deleted_at IS NULL LIMIT 1;
    v_stock_after := v_stock_before + v_qty;

    INSERT INTO "kardex" (
      "kardex_date","product_id","type","doc_id","doc_type","doc_serie",
      "actual_qty","after_qty","incoming_rate","outgoing_rate",
      "valuation_rate","stock_value","created_at","updated_at"
    ) VALUES (
      v_nc_date::date, v_product_id, 'IN', v_nc_id, 'nota_credito', v_nc_serie,
      v_stock_before, v_stock_after, v_price, 0,
      v_valuation, ROUND(v_valuation * v_stock_after, 2), NOW(), NOW()
    );
    UPDATE "product_stock"
    SET stock = v_stock_after, stock_value = ROUND(v_valuation * v_stock_after, 2), updated_at = NOW()
    WHERE product_id = v_product_id AND deleted_at IS NULL;
  END LOOP;
END $$;

-- -----------------------------------------------------------------------------
-- 12. MERMAS
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_adj_id INT;
  v_reason_id INT;
  v_user_id INT;
  v_product_id INT;
  v_product_name TEXT;
  v_qty INT;
  v_valuation NUMERIC(12,2);
  v_subtotal NUMERIC(12,2);
  v_stock_before INT;
  v_stock_after INT;
  v_total_qty INT := 0;
  v_total_value NUMERIC(12,2) := 0;
  v_serie TEXT := 'MER-000001';
  v_date DATE := '2025-08-08';
BEGIN
  SELECT id INTO v_user_id FROM "user" WHERE email = 'carlos.mendoza@tienda.com' LIMIT 1;
  SELECT id INTO v_reason_id FROM "reason" WHERE name = 'EXPIRY' AND status = 'OUT' LIMIT 1;

  INSERT INTO "stock_adjustment" (
    "serie","user_id","stock_adjustment_date","reason_id","reason_name",
    "direction","notes","status","total_qty","total_value","created_at","updated_at"
  ) VALUES (
    v_serie, v_user_id, v_date, v_reason_id, 'EXPIRY',
    'Out', 'Merma por vencimiento', 'confirmado', 0, 0, NOW(), NOW()
  ) RETURNING id INTO v_adj_id;

  FOREACH v_product_name IN ARRAY ARRAY['FAC-004','FAC-005'] LOOP
    SELECT p.id, p.name, ps.stock, ps.valuation_rate
    INTO v_product_id, v_product_name, v_stock_before, v_valuation
    FROM "product" p
    JOIN "product_stock" ps ON ps.product_id = p.id AND ps.deleted_at IS NULL
    WHERE p.sku = v_product_name AND p.deleted_at IS NULL LIMIT 1;

    IF v_product_name LIKE 'FAC-004%' THEN v_qty := LEAST(8, v_stock_before);
    ELSE v_qty := LEAST(6, v_stock_before); END IF;

    v_subtotal := ROUND(v_valuation * v_qty, 2);
    v_total_qty := v_total_qty + v_qty;
    v_total_value := v_total_value + v_subtotal;
    v_stock_after := GREATEST(0, v_stock_before - v_qty);

    INSERT INTO "detail_stock_adjustment" (
      "stock_adjustment_id","product_id","product_name","qty","valuation_rate","subtotal","created_at","updated_at"
    ) VALUES (v_adj_id, v_product_id, v_product_name, v_qty, v_valuation, v_subtotal, NOW(), NOW());

    INSERT INTO "kardex" (
      "kardex_date","product_id","type","doc_id","doc_type","doc_serie",
      "actual_qty","after_qty","incoming_rate","outgoing_rate",
      "valuation_rate","stock_value","created_at","updated_at"
    ) VALUES (
      v_date, v_product_id, 'OUT', v_adj_id, 'merma', v_serie,
      v_stock_before, v_stock_after, 0, v_valuation,
      v_valuation, ROUND(v_valuation * v_stock_after, 2), NOW(), NOW()
    );
    UPDATE "product_stock"
    SET stock = v_stock_after, stock_value = ROUND(v_valuation * v_stock_after, 2), updated_at = NOW()
    WHERE product_id = v_product_id AND deleted_at IS NULL;
  END LOOP;

  UPDATE "stock_adjustment" SET total_qty = v_total_qty, total_value = v_total_value WHERE id = v_adj_id;
END $$;

-- -----------------------------------------------------------------------------
-- 13. CIERRE DE CAJAS (30)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  r_box RECORD;
  v_closed_id INT;
  r_pay RECORD;
  v_opening NUMERIC(12,2);
  v_expected NUMERIC(12,2);
  v_closing NUMERIC(12,2);
  v_end_date TIMESTAMPTZ;
  v_serie TEXT;
  v_n INT := 1;
BEGIN
  FOR r_box IN
    SELECT b.id, b.serie, b.user_id, b.start_date
    FROM "box_open" b
    WHERE b.status = 'abierto' AND b.serie LIKE 'CAJ-%'
    ORDER BY b.serie
  LOOP
    v_end_date := r_box.start_date + INTERVAL '9 hours';
    v_serie := 'CIE-' || LPAD(v_n::TEXT, 6, '0');
    v_n := v_n + 1;

    INSERT INTO "box_closed" (
      "serie","user_id","box_open_id","start_date","end_date",
      "status","notes","created_at","updated_at"
    ) VALUES (
      v_serie, r_box.user_id, r_box.id, r_box.start_date, v_end_date,
      'cerrado', 'Cierre automático – conciliación exacta', NOW(), NOW()
    ) RETURNING id INTO v_closed_id;

    FOR r_pay IN SELECT id, name FROM "payment" WHERE deleted_at IS NULL LOOP
      SELECT COALESCE(SUM(opening_amount), 0) INTO v_opening
      FROM "detail_box_open"
      WHERE box_open_id = r_box.id AND mode_payment = r_pay.id;

      SELECT COALESCE(SUM(sp.amount), 0) INTO v_expected
      FROM "sale_payment" sp
      WHERE sp.box_open_id = r_box.id AND sp.payment_id = r_pay.id;

      v_expected := ROUND(v_opening + v_expected, 2);
      v_closing := v_expected;

      IF v_opening <> 0 OR v_expected <> 0 THEN
        INSERT INTO "detail_box_closed" (
          "box_closed_id","mode_payment","mode_payment_name",
          "opening_amount","expected_amount","closing_amount","difference_amount",
          "created_at","updated_at"
        ) VALUES (
          v_closed_id, r_pay.id, r_pay.name,
          v_opening, v_expected, v_closing, 0, NOW(), NOW()
        );
      END IF;
    END LOOP;

    UPDATE "box_open"
    SET status = 'cerrado', end_date = v_end_date, updated_at = NOW()
    WHERE id = r_box.id;
  END LOOP;
END $$;

-- -----------------------------------------------------------------------------
-- 14. RESUMEN
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  v_sales INT; v_nc INT; v_boxes INT; v_kardex INT; v_mermas INT;
BEGIN
  SELECT COUNT(*) INTO v_sales FROM "sale" WHERE is_return = false;
  SELECT COUNT(*) INTO v_nc FROM "sale" WHERE is_return = true;
  SELECT COUNT(*) INTO v_boxes FROM "box_closed";
  SELECT COUNT(*) INTO v_kardex FROM "kardex";
  SELECT COUNT(*) INTO v_mermas FROM "stock_adjustment";

  RAISE NOTICE '══════════════════════════════════════════════════';
  RAISE NOTICE ' RESUMEN SEED SQL';
  RAISE NOTICE '══════════════════════════════════════════════════';
  RAISE NOTICE 'Ventas (boletas/facturas): %', v_sales;
  RAISE NOTICE 'Notas de Crédito:          %', v_nc;
  RAISE NOTICE 'Cajas cerradas:            %', v_boxes;
  RAISE NOTICE 'Movimientos Kardex:        %', v_kardex;
  RAISE NOTICE 'Mermas registradas:        %', v_mermas;
  RAISE NOTICE '══════════════════════════════════════════════════';
END $$;

COMMIT;
-- =============================================================================
-- SCRIPT DE POBLADO REALISTA - TIENDA COMERCIAL (PERÚ)
-- Generado para simular historial real de los últimos ~10 meses
-- Compatible con schema.prisma + semillas existentes
-- Ejecutar con: prisma db execute --file seed_data.sql  o  psql -f seed_data.sql
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- 1. ROLES
-- -----------------------------------------------------------------------------
INSERT INTO "role" ("id", "name", "description", "created_at", "updated_at")
VALUES
  (1, 'Administrador', 'Acceso total al sistema', '2025-10-01 08:00:00', '2025-10-01 08:00:00'),
  (2, 'Cajero', 'Operaciones de caja, ventas y cobros', '2025-10-01 08:00:00', '2025-10-01 08:00:00'),
  (3, 'Almacenero', 'Gestión de compras, recepciones y stock', '2025-10-01 08:00:00', '2025-10-01 08:00:00'),
  (4, 'Supervisor', 'Lectura de reportes y aprobación de documentos', '2025-10-01 08:00:00', '2025-10-01 08:00:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 2. USUARIOS (contraseñas hasheadas de ejemplo - bcrypt de "password123")
-- -----------------------------------------------------------------------------
INSERT INTO "user" ("id", "name", "email", "password", "image_url", "created_at", "updated_at")
VALUES
  (1, 'Carlos Mendoza', 'carlos.mendoza@tienda.com', '$2b$10$rQZ8K8Y5Y5Y5Y5Y5Y5Y5Yu', NULL, '2025-10-05 09:15:00', '2025-10-05 09:15:00'),
  (2, 'María López Vargas', 'maria.lopez@tienda.com', '$2b$10$rQZ8K8Y5Y5Y5Y5Y5Y5Y5Yu', NULL, '2025-10-08 10:30:00', '2025-10-08 10:30:00'),
  (3, 'José Ramírez Quispe', 'jose.ramirez@tienda.com', '$2b$10$rQZ8K8Y5Y5Y5Y5Y5Y5Y5Yu', NULL, '2025-10-12 11:00:00', '2025-10-12 11:00:00'),
  (4, 'Ana Torres Rojas', 'ana.torres@tienda.com', '$2b$10$rQZ8K8Y5Y5Y5Y5Y5Y5Y5Yu', NULL, '2025-11-03 08:45:00', '2025-11-03 08:45:00'),
  (5, 'Luis Fernández Soto', 'luis.fernandez@tienda.com', '$2b$10$rQZ8K8Y5Y5Y5Y5Y5Y5Y5Yu', NULL, '2025-11-15 14:20:00', '2025-11-15 14:20:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 3. USER_ROLE
-- -----------------------------------------------------------------------------
INSERT INTO "user_role" ("id", "user_id", "role_id", "created_at")
VALUES
  (1, 1, 1, '2025-10-05 09:20:00'),  -- Carlos = Administrador
  (2, 2, 2, '2025-10-08 10:35:00'),  -- María = Cajero
  (3, 3, 3, '2025-10-12 11:05:00'),  -- José = Almacenero
  (4, 4, 2, '2025-11-03 08:50:00'),  -- Ana = Cajero
  (5, 5, 4, '2025-11-15 14:25:00'),  -- Luis = Supervisor
  (6, 1, 4, '2025-10-05 09:20:00')   -- Carlos también Supervisor
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 4. ROLE_PERMISSION (muestra representativa – no se asignan todos por longitud)
-- -----------------------------------------------------------------------------
INSERT INTO "role_permission" ("role_id", "permission_id", "created_at")
SELECT 1, id, '2025-10-05 09:25:00' FROM "permission"  -- Admin tiene todos
ON CONFLICT DO NOTHING;

INSERT INTO "role_permission" ("role_id", "permission_id", "created_at")
SELECT 2, id, '2025-10-08 10:40:00' FROM "permission"
WHERE name IN (
  'sale:create', 'sale:byid', 'sale:readid', 'box-open:create',
  'box-closed:create', 'customers:read', 'products:read-catalog',
  'payments:read'
)
ON CONFLICT DO NOTHING;

INSERT INTO "role_permission" ("role_id", "permission_id", "created_at")
SELECT 3, id, '2025-10-12 11:10:00' FROM "permission"
WHERE name LIKE 'purchase:%' OR name LIKE 'receipt:%'
   OR name LIKE 'stock-adjustment:%' OR name LIKE 'products:%'
   OR name LIKE 'suppliers:%' OR name LIKE 'categories:%'
ON CONFLICT DO NOTHING;

-- -----------------------------------------------------------------------------
-- 5. CATEGORÍAS
-- -----------------------------------------------------------------------------
INSERT INTO "category" ("id", "name", "description", "created_at")
VALUES
  (1, 'Bebidas', 'Gaseosas, jugos, aguas y bebidas energéticas', '2025-10-10 09:00:00'),
  (2, 'Abarrotes', 'Arroz, fideos, aceite, azúcar, legumbres', '2025-10-10 09:00:00'),
  (3, 'Lácteos y Huevos', 'Leche, yogurt, queso, mantequilla, huevos', '2025-10-10 09:00:00'),
  (4, 'Snacks y Galletas', 'Papas fritas, galletas, chocolates, golosinas', '2025-10-10 09:00:00'),
  (5, 'Cuidado Personal', 'Jabones, shampoo, pasta dental, papel higiénico', '2025-10-10 09:00:00'),
  (6, 'Limpieza del Hogar', 'Detergentes, desinfectantes, cloro, esponjas', '2025-10-10 09:00:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 6. PROVEEDORES
-- -----------------------------------------------------------------------------
INSERT INTO "supplier" ("id", "name", "type", "ruc", "email", "phone", "created_at")
VALUES
  (1, 'Distribuidora Inca Kola S.A.C.', 'juridico', '20100047218', 'pedidos@incakola.com.pe', '01-613-2000', '2025-10-15 10:00:00'),
  (2, 'Alicorp S.A.A.', 'juridico', '20100055237', 'ventas@alicorp.com.pe', '01-315-0800', '2025-10-15 10:15:00'),
  (3, 'Gloria S.A.', 'juridico', '20100113610', 'distribucion@gloria.com.pe', '01-315-0500', '2025-10-16 09:30:00'),
  (4, 'Procter & Gamble Perú S.R.L.', 'juridico', '20100039207', 'pedidos.pe@pg.com', '01-615-5000', '2025-10-18 11:00:00'),
  (5, 'Distribuidora San Martín E.I.R.L.', 'juridico', '20512345678', 'contacto@sanmartin.pe', '01-456-7890', '2025-11-05 14:00:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 7. CLIENTES ADICIONALES (además del genérico ya sembrado)
-- -----------------------------------------------------------------------------
INSERT INTO "customer" ("id", "doc_type_code", "doc_type_name", "doc_type_number", "name", "is_generic", "email", "phone", "created_at", "updated_at")
VALUES
  (2, '01', 'DNI', '45678912', 'Roberto Carlos Gómez Huamán', false, 'roberto.gomez@gmail.com', '987654321', '2025-10-20 12:00:00', '2025-10-20 12:00:00'),
  (3, '01', 'DNI', '71234567', 'Patricia Elena Vargas Mendoza', false, 'patricia.vargas@outlook.com', '912345678', '2025-10-22 15:30:00', '2025-10-22 15:30:00'),
  (4, '06', 'RUC', '20567890123', 'Minimarket El Sol S.A.C.', false, 'compras@elsol.pe', '01-234-5678', '2025-11-01 10:00:00', '2025-11-01 10:00:00'),
  (5, '01', 'DNI', '40321654', 'Juan Pablo Quispe Rojas', false, NULL, '945612378', '2025-11-10 16:45:00', '2025-11-10 16:45:00'),
  (6, '01', 'DNI', '75891234', 'Sofía Isabel Chávez Torres', false, 'sofia.chavez@yahoo.com', '998877665', '2025-11-18 09:20:00', '2025-11-18 09:20:00'),
  (7, '04', 'CE', '001234567', 'Miguel Ángel Fernández López', false, 'miguelf@email.com', '976543210', '2025-12-02 11:10:00', '2025-12-02 11:10:00'),
  (8, '01', 'DNI', '46789123', 'Carmen Rosa Paredes Silva', false, NULL, '934567890', '2025-12-15 14:00:00', '2025-12-15 14:00:00'),
  (9, '06', 'RUC', '20601234567', 'Restaurante La Casona E.I.R.L.', false, 'admin@lacasona.pe', '01-345-6789', '2026-01-08 10:30:00', '2026-01-08 10:30:00'),
  (10, '01', 'DNI', '78901234', 'Diego Alejandro Soto Ramírez', false, 'diego.soto@gmail.com', '987123456', '2026-02-05 13:15:00', '2026-02-05 13:15:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 8. PRODUCTOS
-- -----------------------------------------------------------------------------
INSERT INTO "product" ("id", "sku", "name", "description", "image", "min_order_qty", "min_stock", "status", "category_id", "created_at", "updated_at")
VALUES
  -- Bebidas
  (1, 'BEB-001', 'Inca Kola 2.25L', 'Gaseosa Inca Kola botella PET 2.25 litros', '/images/incakola-225.jpg', 6, 24, true, 1, '2025-10-12 10:00:00', '2025-10-12 10:00:00'),
  (2, 'BEB-002', 'Coca Cola 2.25L', 'Gaseosa Coca Cola botella PET 2.25 litros', '/images/cocacola-225.jpg', 6, 24, true, 1, '2025-10-12 10:05:00', '2025-10-12 10:05:00'),
  (3, 'BEB-003', 'Agua San Luis 625ml', 'Agua de mesa San Luis sin gas 625 ml', '/images/sanluis-625.jpg', 12, 48, true, 1, '2025-10-12 10:10:00', '2025-10-12 10:10:00'),
  (4, 'BEB-004', 'Sporade 500ml', 'Bebida rehidratante Sporade sabor naranja 500 ml', '/images/sporade-500.jpg', 12, 36, true, 1, '2025-10-12 10:15:00', '2025-10-12 10:15:00'),
  -- Abarrotes
  (5, 'ABA-001', 'Arroz Costeño Extra 5kg', 'Arroz superior Costeño bolsa de 5 kilogramos', '/images/arroz-costeno-5kg.jpg', 4, 20, true, 2, '2025-10-12 10:20:00', '2025-10-12 10:20:00'),
  (6, 'ABA-002', 'Aceite Primor 1L', 'Aceite vegetal Primor botella 1 litro', '/images/aceite-primor-1l.jpg', 12, 36, true, 2, '2025-10-12 10:25:00', '2025-10-12 10:25:00'),
  (7, 'ABA-003', 'Azúcar Rubia Cartavio 1kg', 'Azúcar rubia Cartavio bolsa 1 kilogramo', '/images/azucar-cartavio.jpg', 12, 40, true, 2, '2025-10-12 10:30:00', '2025-10-12 10:30:00'),
  (8, 'ABA-004', 'Fideos Don Vittorio Spaghetti 500g', 'Pasta spaghetti Don Vittorio 500 gramos', '/images/don-vittorio.jpg', 20, 60, true, 2, '2025-10-12 10:35:00', '2025-10-12 10:35:00'),
  -- Lácteos
  (9, 'LAC-001', 'Leche Gloria Entera 1L', 'Leche evaporada Gloria tetra pack 1 litro', '/images/gloria-1l.jpg', 12, 48, true, 3, '2025-10-12 10:40:00', '2025-10-12 10:40:00'),
  (10, 'LAC-002', 'Yogurt Gloria Frutado 1kg', 'Yogurt Gloria sabor fresa 1 kilogramo', '/images/yogurt-gloria.jpg', 8, 24, true, 3, '2025-10-12 10:45:00', '2025-10-12 10:45:00'),
  (11, 'LAC-003', 'Huevos Pardos x30', 'Huevos de gallina pardos bandeja de 30 unidades', '/images/huevos-30.jpg', 5, 15, true, 3, '2025-10-12 10:50:00', '2025-10-12 10:50:00'),
  -- Snacks
  (12, 'SNA-001', 'Lay''s Clásicas 150g', 'Papas fritas Lay''s sabor original 150 gramos', '/images/lays-150.jpg', 12, 36, true, 4, '2025-10-12 10:55:00', '2025-10-12 10:55:00'),
  (13, 'SNA-002', 'Galletas Oreo 117g', 'Galletas Oreo rellenas de crema 117 gramos', '/images/oreo-117.jpg', 20, 48, true, 4, '2025-10-12 11:00:00', '2025-10-12 11:00:00'),
  (14, 'SNA-003', 'Chocolate Sublime 30g', 'Chocolate Sublime con maní 30 gramos', '/images/sublime-30.jpg', 30, 90, true, 4, '2025-10-12 11:05:00', '2025-10-12 11:05:00'),
  -- Cuidado Personal
  (15, 'CUI-001', 'Jabón Protex 110g', 'Jabón antibacterial Protex barra 110 gramos', '/images/protex-110.jpg', 24, 72, true, 5, '2025-10-12 11:10:00', '2025-10-12 11:10:00'),
  (16, 'CUI-002', 'Pasta Dental Colgate 90g', 'Pasta dental Colgate Triple Acción 90 gramos', '/images/colgate-90.jpg', 12, 36, true, 5, '2025-10-12 11:15:00', '2025-10-12 11:15:00'),
  (17, 'CUI-003', 'Papel Higiénico Suave 4 rollos', 'Papel higiénico Suave doble hoja pack 4 rollos', '/images/suave-4.jpg', 10, 30, true, 5, '2025-10-12 11:20:00', '2025-10-12 11:20:00'),
  -- Limpieza
  (18, 'LIM-001', 'Detergente Ace 1kg', 'Detergente en polvo Ace Regular 1 kilogramo', '/images/ace-1kg.jpg', 8, 24, true, 6, '2025-10-12 11:25:00', '2025-10-12 11:25:00'),
  (19, 'LIM-002', 'Cloro Sapolio 1L', 'Cloro desinfectante Sapolio botella 1 litro', '/images/sapolio-1l.jpg', 12, 36, true, 6, '2025-10-12 11:30:00', '2025-10-12 11:30:00'),
  (20, 'LIM-003', 'Lavavajillas Ayudín 750ml', 'Lavavajillas líquido Ayudín limón 750 ml', '/images/ayudin-750.jpg', 12, 36, true, 6, '2025-10-12 11:35:00', '2025-10-12 11:35:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 9. PRECIOS DE PRODUCTOS (compra y venta)
-- -----------------------------------------------------------------------------
INSERT INTO "product_price" ("id", "product_id", "product_name", "product_description", "buying", "selling", "amount", "created_at", "updated_at")
VALUES
  -- Compra
  (1, 1, 'Inca Kola 2.25L', 'Gaseosa Inca Kola botella PET 2.25 litros', true, false, 4.20, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (2, 2, 'Coca Cola 2.25L', 'Gaseosa Coca Cola botella PET 2.25 litros', true, false, 4.10, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (3, 3, 'Agua San Luis 625ml', 'Agua de mesa San Luis sin gas 625 ml', true, false, 0.85, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (4, 4, 'Sporade 500ml', 'Bebida rehidratante Sporade sabor naranja 500 ml', true, false, 1.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (5, 5, 'Arroz Costeño Extra 5kg', 'Arroz superior Costeño bolsa de 5 kilogramos', true, false, 18.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (6, 6, 'Aceite Primor 1L', 'Aceite vegetal Primor botella 1 litro', true, false, 7.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (7, 7, 'Azúcar Rubia Cartavio 1kg', 'Azúcar rubia Cartavio bolsa 1 kilogramo', true, false, 3.40, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (8, 8, 'Fideos Don Vittorio Spaghetti 500g', 'Pasta spaghetti Don Vittorio 500 gramos', true, false, 2.10, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (9, 9, 'Leche Gloria Entera 1L', 'Leche evaporada Gloria tetra pack 1 litro', true, false, 4.60, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (10, 10, 'Yogurt Gloria Frutado 1kg', 'Yogurt Gloria sabor fresa 1 kilogramo', true, false, 5.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (11, 11, 'Huevos Pardos x30', 'Huevos de gallina pardos bandeja de 30 unidades', true, false, 14.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (12, 12, 'Lay''s Clásicas 150g', 'Papas fritas Lay''s sabor original 150 gramos', true, false, 3.20, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (13, 13, 'Galletas Oreo 117g', 'Galletas Oreo rellenas de crema 117 gramos', true, false, 2.40, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (14, 14, 'Chocolate Sublime 30g', 'Chocolate Sublime con maní 30 gramos', true, false, 1.10, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (15, 15, 'Jabón Protex 110g', 'Jabón antibacterial Protex barra 110 gramos', true, false, 2.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (16, 16, 'Pasta Dental Colgate 90g', 'Pasta dental Colgate Triple Acción 90 gramos', true, false, 4.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (17, 17, 'Papel Higiénico Suave 4 rollos', 'Papel higiénico Suave doble hoja pack 4 rollos', true, false, 6.20, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (18, 18, 'Detergente Ace 1kg', 'Detergente en polvo Ace Regular 1 kilogramo', true, false, 8.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (19, 19, 'Cloro Sapolio 1L', 'Cloro desinfectante Sapolio botella 1 litro', true, false, 3.10, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (20, 20, 'Lavavajillas Ayudín 750ml', 'Lavavajillas líquido Ayudín limón 750 ml', true, false, 4.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  -- Venta
  (21, 1, 'Inca Kola 2.25L', 'Gaseosa Inca Kola botella PET 2.25 litros', false, true, 5.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (22, 2, 'Coca Cola 2.25L', 'Gaseosa Coca Cola botella PET 2.25 litros', false, true, 5.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (23, 3, 'Agua San Luis 625ml', 'Agua de mesa San Luis sin gas 625 ml', false, true, 1.20, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (24, 4, 'Sporade 500ml', 'Bebida rehidratante Sporade sabor naranja 500 ml', false, true, 2.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (25, 5, 'Arroz Costeño Extra 5kg', 'Arroz superior Costeño bolsa de 5 kilogramos', false, true, 22.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (26, 6, 'Aceite Primor 1L', 'Aceite vegetal Primor botella 1 litro', false, true, 9.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (27, 7, 'Azúcar Rubia Cartavio 1kg', 'Azúcar rubia Cartavio bolsa 1 kilogramo', false, true, 4.20, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (28, 8, 'Fideos Don Vittorio Spaghetti 500g', 'Pasta spaghetti Don Vittorio 500 gramos', false, true, 2.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (29, 9, 'Leche Gloria Entera 1L', 'Leche evaporada Gloria tetra pack 1 litro', false, true, 5.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (30, 10, 'Yogurt Gloria Frutado 1kg', 'Yogurt Gloria sabor fresa 1 kilogramo', false, true, 7.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (31, 11, 'Huevos Pardos x30', 'Huevos de gallina pardos bandeja de 30 unidades', false, true, 18.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (32, 12, 'Lay''s Clásicas 150g', 'Papas fritas Lay''s sabor original 150 gramos', false, true, 4.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (33, 13, 'Galletas Oreo 117g', 'Galletas Oreo rellenas de crema 117 gramos', false, true, 3.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (34, 14, 'Chocolate Sublime 30g', 'Chocolate Sublime con maní 30 gramos', false, true, 1.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (35, 15, 'Jabón Protex 110g', 'Jabón antibacterial Protex barra 110 gramos', false, true, 3.80, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (36, 16, 'Pasta Dental Colgate 90g', 'Pasta dental Colgate Triple Acción 90 gramos', false, true, 5.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (37, 17, 'Papel Higiénico Suave 4 rollos', 'Papel higiénico Suave doble hoja pack 4 rollos', false, true, 8.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (38, 18, 'Detergente Ace 1kg', 'Detergente en polvo Ace Regular 1 kilogramo', false, true, 11.90, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (39, 19, 'Cloro Sapolio 1L', 'Cloro desinfectante Sapolio botella 1 litro', false, true, 4.20, '2025-10-12 12:00:00', '2025-10-12 12:00:00'),
  (40, 20, 'Lavavajillas Ayudín 750ml', 'Lavavajillas líquido Ayudín limón 750 ml', false, true, 6.50, '2025-10-12 12:00:00', '2025-10-12 12:00:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 10. STOCK INICIAL (antes de cualquier movimiento)
--    Se actualizará al final según movimientos reales
-- -----------------------------------------------------------------------------
INSERT INTO "product_stock" ("id", "product_id", "stock", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (1, 1, 120, 4.20, 504.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (2, 2, 100, 4.10, 410.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (3, 3, 200, 0.85, 170.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (4, 4, 80, 1.80, 144.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (5, 5, 60, 18.50, 1110.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (6, 6, 90, 7.80, 702.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (7, 7, 100, 3.40, 340.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (8, 8, 150, 2.10, 315.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (9, 9, 120, 4.60, 552.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (10, 10, 50, 5.90, 295.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (11, 11, 40, 14.50, 580.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (12, 12, 80, 3.20, 256.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (13, 13, 100, 2.40, 240.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (14, 14, 200, 1.10, 220.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (15, 15, 90, 2.80, 252.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (16, 16, 60, 4.50, 270.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (17, 17, 50, 6.20, 310.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (18, 18, 40, 8.90, 356.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (19, 19, 70, 3.10, 217.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00'),
  (20, 20, 60, 4.80, 288.00, '2025-10-12 13:00:00', '2025-10-12 13:00:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 11. ÓRDENES DE COMPRA + DETALLES + RECEPCIONES + KARDEX
--     (simulación de reposición realista a lo largo del tiempo)
-- -----------------------------------------------------------------------------

-- Orden de compra 1 (Noviembre 2025) - Bebidas y abarrotes
INSERT INTO "order_purchase" ("id", "serie", "supplier_id", "supplier_name", "supplier_ruc", "status", "address_purchase", "delivery_date", "total", "user_id", "created_at", "updated_at")
VALUES
  (1, 'OC-2025-0001', 1, 'Distribuidora Inca Kola S.A.C.', '20100047218', 'recibido', 'Av. La Marina 1234, San Miguel, Lima', '2025-11-12', 1260.00, 3, '2025-11-05 10:00:00', '2025-11-12 16:00:00');

INSERT INTO "detail_order_purchase" ("id", "purchase_id", "product_id", "product_name", "qty_received", "qty", "price", "subtotal", "created_at", "updated_at")
VALUES
  (1, 1, 1, 'Inca Kola 2.25L', 120, 120, 4.20, 504.00, '2025-11-05 10:05:00', '2025-11-12 16:00:00'),
  (2, 1, 2, 'Coca Cola 2.25L', 100, 100, 4.10, 410.00, '2025-11-05 10:05:00', '2025-11-12 16:00:00'),
  (3, 1, 3, 'Agua San Luis 625ml', 200, 200, 0.85, 170.00, '2025-11-05 10:05:00', '2025-11-12 16:00:00'),
  (4, 1, 4, 'Sporade 500ml', 98, 100, 1.80, 176.00, '2025-11-05 10:05:00', '2025-11-12 16:00:00');  -- 2 rechazados

-- Recepción de la orden 1
INSERT INTO "receipt_purchase" ("id", "serie", "purchase_id", "status", "supplier_id", "supplier_name", "supplier_ruc", "date_receipt", "note", "total", "user_id", "created_at", "updated_at")
VALUES
  (1, 'RC-2025-0001', 1, 'confirmado', 1, 'Distribuidora Inca Kola S.A.C.', '20100047218', '2025-11-12', 'Recepción completa con 2 unidades de Sporade rechazadas por abolladura', 1256.40, 3, '2025-11-12 15:30:00', '2025-11-12 16:00:00');

INSERT INTO "detail_receipt_purchase" ("id", "receipt_id", "detail_purchase_id", "product_id", "product_name", "qty_received", "qty_reject", "qty_accepted", "price", "subtotal", "created_at", "updated_at")
VALUES
  (1, 1, 1, 1, 'Inca Kola 2.25L', 120, 0, 120, 4.20, 504.00, '2025-11-12 15:35:00', '2025-11-12 16:00:00'),
  (2, 1, 2, 2, 'Coca Cola 2.25L', 100, 0, 100, 4.10, 410.00, '2025-11-12 15:35:00', '2025-11-12 16:00:00'),
  (3, 1, 3, 3, 'Agua San Luis 625ml', 200, 0, 200, 0.85, 170.00, '2025-11-12 15:35:00', '2025-11-12 16:00:00'),
  (4, 1, 4, 4, 'Sporade 500ml', 100, 2, 98, 1.80, 176.40, '2025-11-12 15:35:00', '2025-11-12 16:00:00');

-- Kardex de entrada de la recepción 1
INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (1, '2025-11-12', 1, 'IN', 1, 'recepcion', 'RC-2025-0001', 120, 240, 4.20, 0, 4.20, 1008.00, '2025-11-12 16:05:00', '2025-11-12 16:05:00'),
  (2, '2025-11-12', 2, 'IN', 1, 'recepcion', 'RC-2025-0001', 100, 200, 4.10, 0, 4.10, 820.00, '2025-11-12 16:05:00', '2025-11-12 16:05:00'),
  (3, '2025-11-12', 3, 'IN', 1, 'recepcion', 'RC-2025-0001', 200, 400, 0.85, 0, 0.85, 340.00, '2025-11-12 16:05:00', '2025-11-12 16:05:00'),
  (4, '2025-11-12', 4, 'IN', 1, 'recepcion', 'RC-2025-0001', 80, 178, 1.80, 0, 1.80, 320.40, '2025-11-12 16:05:00', '2025-11-12 16:05:00');

-- Orden de compra 2 (Diciembre 2025) - Abarrotes y lácteos
INSERT INTO "order_purchase" ("id", "serie", "supplier_id", "supplier_name", "supplier_ruc", "status", "address_purchase", "delivery_date", "total", "user_id", "created_at", "updated_at")
VALUES
  (2, 'OC-2025-0002', 2, 'Alicorp S.A.A.', '20100055237', 'recibido', 'Av. La Marina 1234, San Miguel, Lima', '2025-12-18', 1895.00, 3, '2025-12-10 09:30:00', '2025-12-18 14:00:00');

INSERT INTO "detail_order_purchase" ("id", "purchase_id", "product_id", "product_name", "qty_received", "qty", "price", "subtotal", "created_at", "updated_at")
VALUES
  (5, 2, 5, 'Arroz Costeño Extra 5kg', 40, 40, 18.50, 740.00, '2025-12-10 09:35:00', '2025-12-18 14:00:00'),
  (6, 2, 6, 'Aceite Primor 1L', 60, 60, 7.80, 468.00, '2025-12-10 09:35:00', '2025-12-18 14:00:00'),
  (7, 2, 7, 'Azúcar Rubia Cartavio 1kg', 80, 80, 3.40, 272.00, '2025-12-10 09:35:00', '2025-12-18 14:00:00'),
  (8, 2, 8, 'Fideos Don Vittorio Spaghetti 500g', 100, 100, 2.10, 210.00, '2025-12-10 09:35:00', '2025-12-18 14:00:00'),
  (9, 2, 9, 'Leche Gloria Entera 1L', 40, 40, 4.60, 184.00, '2025-12-10 09:35:00', '2025-12-18 14:00:00');

INSERT INTO "receipt_purchase" ("id", "serie", "purchase_id", "status", "supplier_id", "supplier_name", "supplier_ruc", "date_receipt", "note", "total", "user_id", "created_at", "updated_at")
VALUES
  (2, 'RC-2025-0002', 2, 'confirmado', 2, 'Alicorp S.A.A.', '20100055237', '2025-12-18', 'Recepción sin observaciones', 1874.00, 3, '2025-12-18 13:45:00', '2025-12-18 14:00:00');

INSERT INTO "detail_receipt_purchase" ("id", "receipt_id", "detail_purchase_id", "product_id", "product_name", "qty_received", "qty_reject", "qty_accepted", "price", "subtotal", "created_at", "updated_at")
VALUES
  (5, 2, 5, 5, 'Arroz Costeño Extra 5kg', 40, 0, 40, 18.50, 740.00, '2025-12-18 13:50:00', '2025-12-18 14:00:00'),
  (6, 2, 6, 6, 'Aceite Primor 1L', 60, 0, 60, 7.80, 468.00, '2025-12-18 13:50:00', '2025-12-18 14:00:00'),
  (7, 2, 7, 7, 'Azúcar Rubia Cartavio 1kg', 80, 0, 80, 3.40, 272.00, '2025-12-18 13:50:00', '2025-12-18 14:00:00'),
  (8, 2, 8, 8, 'Fideos Don Vittorio Spaghetti 500g', 100, 0, 100, 2.10, 210.00, '2025-12-18 13:50:00', '2025-12-18 14:00:00'),
  (9, 2, 9, 9, 'Leche Gloria Entera 1L', 40, 0, 40, 4.60, 184.00, '2025-12-18 13:50:00', '2025-12-18 14:00:00');

INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (5, '2025-12-18', 5, 'IN', 2, 'recepcion', 'RC-2025-0002', 60, 100, 18.50, 0, 18.50, 1850.00, '2025-12-18 14:05:00', '2025-12-18 14:05:00'),
  (6, '2025-12-18', 6, 'IN', 2, 'recepcion', 'RC-2025-0002', 90, 150, 7.80, 0, 7.80, 1170.00, '2025-12-18 14:05:00', '2025-12-18 14:05:00'),
  (7, '2025-12-18', 7, 'IN', 2, 'recepcion', 'RC-2025-0002', 100, 180, 3.40, 0, 3.40, 612.00, '2025-12-18 14:05:00', '2025-12-18 14:05:00'),
  (8, '2025-12-18', 8, 'IN', 2, 'recepcion', 'RC-2025-0002', 150, 250, 2.10, 0, 2.10, 525.00, '2025-12-18 14:05:00', '2025-12-18 14:05:00'),
  (9, '2025-12-18', 9, 'IN', 2, 'recepcion', 'RC-2025-0002', 120, 160, 4.60, 0, 4.60, 736.00, '2025-12-18 14:05:00', '2025-12-18 14:05:00');

-- -----------------------------------------------------------------------------
-- 12. APERTURAS DE CAJA (box_open)
-- -----------------------------------------------------------------------------
INSERT INTO "box_open" ("id", "serie", "user_id", "start_date", "end_date", "status", "notes", "created_at", "updated_at")
VALUES
  (1, 'CAJA-2025-1101', 2, '2025-11-15 08:00:00', '2025-11-15 22:05:00', 'cerrado', 'Turno mañana-tarde', '2025-11-15 08:00:00', '2025-11-15 22:05:00'),
  (2, 'CAJA-2025-1205', 2, '2025-12-05 08:00:00', '2025-12-05 21:45:00', 'cerrado', NULL, '2025-12-05 08:00:00', '2025-12-05 21:45:00'),
  (3, 'CAJA-2026-0110', 4, '2026-01-10 08:00:00', '2026-01-10 22:10:00', 'cerrado', 'Fin de semana', '2026-01-10 08:00:00', '2026-01-10 22:10:00'),
  (4, 'CAJA-2026-0215', 2, '2026-02-15 08:00:00', '2026-02-15 21:30:00', 'cerrado', NULL, '2026-02-15 08:00:00', '2026-02-15 21:30:00'),
  (5, 'CAJA-2026-0308', 4, '2026-03-08 08:00:00', NULL, 'abierto', 'Caja actual en operación', '2026-03-08 08:00:00', '2026-03-08 08:00:00')
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "detail_box_open" ("id", "box_open_id", "mode_payment", "opening_amount", "created_at", "updated_at")
VALUES
  (1, 1, 1, 200.00, '2025-11-15 08:02:00', '2025-11-15 08:02:00'),  -- Efectivo
  (2, 1, 2, 0.00, '2025-11-15 08:02:00', '2025-11-15 08:02:00'),   -- Tarjeta
  (3, 1, 3, 0.00, '2025-11-15 08:02:00', '2025-11-15 08:02:00'),   -- Yape
  (4, 2, 1, 250.00, '2025-12-05 08:02:00', '2025-12-05 08:02:00'),
  (5, 2, 2, 0.00, '2025-12-05 08:02:00', '2025-12-05 08:02:00'),
  (6, 2, 3, 0.00, '2025-12-05 08:02:00', '2025-12-05 08:02:00'),
  (7, 3, 1, 300.00, '2026-01-10 08:02:00', '2026-01-10 08:02:00'),
  (8, 3, 2, 0.00, '2026-01-10 08:02:00', '2026-01-10 08:02:00'),
  (9, 3, 3, 0.00, '2026-01-10 08:02:00', '2026-01-10 08:02:00'),
  (10, 4, 1, 200.00, '2026-02-15 08:02:00', '2026-02-15 08:02:00'),
  (11, 4, 2, 0.00, '2026-02-15 08:02:00', '2026-02-15 08:02:00'),
  (12, 4, 3, 0.00, '2026-02-15 08:02:00', '2026-02-15 08:02:00'),
  (13, 5, 1, 250.00, '2026-03-08 08:02:00', '2026-03-08 08:02:00'),
  (14, 5, 2, 0.00, '2026-03-08 08:02:00', '2026-03-08 08:02:00'),
  (15, 5, 3, 0.00, '2026-03-08 08:02:00', '2026-03-08 08:02:00')
ON CONFLICT ("id") DO NOTHING;

-- -----------------------------------------------------------------------------
-- 13. VENTAS + DETALLES + PAGOS (ejemplos realistas)
--     IGV 18% - se calcula sobre base imponible
-- -----------------------------------------------------------------------------

-- Venta 1 (Boleta - Cliente genérico)
INSERT INTO "sale" ("id", "serie", "box_open_id", "type_code", "user_id", "sale_date", "customer_id", "customer_name", "customer_doc_code", "customer_doc_number", "igv_rate", "taxable_amount", "igv_total", "total", "paid_amount", "change_amount", "is_return", "created_at", "updated_at")
VALUES
  (1, 'B001-00000001', 1, '03', 2, '2025-11-15 10:25:00', 1, 'CLIENTES VARIOS', '01', '00000000', 18.00, 25.42, 4.58, 30.00, 50.00, 20.00, false, '2025-11-15 10:25:00', '2025-11-15 10:25:00');

INSERT INTO "detail_sale" ("id", "sale_id", "product_id", "product_name", "qty", "price", "subtotal", "created_at", "updated_at")
VALUES
  (1, 1, 1, 'Inca Kola 2.25L', 2, 5.50, 11.00, '2025-11-15 10:25:00', '2025-11-15 10:25:00'),
  (2, 1, 14, 'Chocolate Sublime 30g', 4, 1.50, 6.00, '2025-11-15 10:25:00', '2025-11-15 10:25:00'),
  (3, 1, 3, 'Agua San Luis 625ml', 5, 1.20, 6.00, '2025-11-15 10:25:00', '2025-11-15 10:25:00'),
  (4, 1, 13, 'Galletas Oreo 117g', 2, 3.50, 7.00, '2025-11-15 10:25:00', '2025-11-15 10:25:00');

INSERT INTO "sale_payment" ("id", "sale_id", "box_open_id", "payment_id", "payment_name", "amount", "created_at", "updated_at")
VALUES
  (1, 1, 1, 1, 'Efectivo', 50.00, '2025-11-15 10:26:00', '2025-11-15 10:26:00');

-- Kardex de salida venta 1
INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (10, '2025-11-15', 1, 'OUT', 1, 'venta', 'B001-00000001', 240, 238, 0, 5.50, 4.20, 999.60, '2025-11-15 10:27:00', '2025-11-15 10:27:00'),
  (11, '2025-11-15', 14, 'OUT', 1, 'venta', 'B001-00000001', 200, 196, 0, 1.50, 1.10, 215.60, '2025-11-15 10:27:00', '2025-11-15 10:27:00'),
  (12, '2025-11-15', 3, 'OUT', 1, 'venta', 'B001-00000001', 400, 395, 0, 1.20, 0.85, 335.75, '2025-11-15 10:27:00', '2025-11-15 10:27:00'),
  (13, '2025-11-15', 13, 'OUT', 1, 'venta', 'B001-00000001', 100, 98, 0, 3.50, 2.40, 235.20, '2025-11-15 10:27:00', '2025-11-15 10:27:00');

-- Venta 2 (Factura - Cliente con RUC)
INSERT INTO "sale" ("id", "serie", "box_open_id", "type_code", "user_id", "sale_date", "customer_id", "customer_name", "customer_doc_code", "customer_doc_number", "igv_rate", "taxable_amount", "igv_total", "total", "paid_amount", "change_amount", "is_return", "created_at", "updated_at")
VALUES
  (2, 'F001-00000001', 1, '01', 2, '2025-11-15 14:40:00', 4, 'Minimarket El Sol S.A.C.', '06', '20567890123', 18.00, 152.54, 27.46, 180.00, 180.00, 0.00, false, '2025-11-15 14:40:00', '2025-11-15 14:40:00');

INSERT INTO "detail_sale" ("id", "sale_id", "product_id", "product_name", "qty", "price", "subtotal", "created_at", "updated_at")
VALUES
  (5, 2, 5, 'Arroz Costeño Extra 5kg', 4, 22.90, 91.60, '2025-11-15 14:40:00', '2025-11-15 14:40:00'),
  (6, 2, 6, 'Aceite Primor 1L', 6, 9.90, 59.40, '2025-11-15 14:40:00', '2025-11-15 14:40:00'),
  (7, 2, 9, 'Leche Gloria Entera 1L', 5, 5.80, 29.00, '2025-11-15 14:40:00', '2025-11-15 14:40:00');

INSERT INTO "sale_payment" ("id", "sale_id", "box_open_id", "payment_id", "payment_name", "amount", "created_at", "updated_at")
VALUES
  (2, 2, 1, 2, 'Tarjeta de Crédito', 180.00, '2025-11-15 14:41:00', '2025-11-15 14:41:00');

INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (14, '2025-11-15', 5, 'OUT', 2, 'venta', 'F001-00000001', 100, 96, 0, 22.90, 18.50, 1776.00, '2025-11-15 14:42:00', '2025-11-15 14:42:00'),
  (15, '2025-11-15', 6, 'OUT', 2, 'venta', 'F001-00000001', 150, 144, 0, 9.90, 7.80, 1123.20, '2025-11-15 14:42:00', '2025-11-15 14:42:00'),
  (16, '2025-11-15', 9, 'OUT', 2, 'venta', 'F001-00000001', 160, 155, 0, 5.80, 4.60, 713.00, '2025-11-15 14:42:00', '2025-11-15 14:42:00');

-- Venta 3 (Boleta - Yape)
INSERT INTO "sale" ("id", "serie", "box_open_id", "type_code", "user_id", "sale_date", "customer_id", "customer_name", "customer_doc_code", "customer_doc_number", "igv_rate", "taxable_amount", "igv_total", "total", "paid_amount", "change_amount", "is_return", "created_at", "updated_at")
VALUES
  (3, 'B001-00000002', 2, '03', 2, '2025-12-05 11:15:00', 2, 'Roberto Carlos Gómez Huamán', '01', '45678912', 18.00, 42.37, 7.63, 50.00, 50.00, 0.00, false, '2025-12-05 11:15:00', '2025-12-05 11:15:00');

INSERT INTO "detail_sale" ("id", "sale_id", "product_id", "product_name", "qty", "price", "subtotal", "created_at", "updated_at")
VALUES
  (8, 3, 11, 'Huevos Pardos x30', 1, 18.90, 18.90, '2025-12-05 11:15:00', '2025-12-05 11:15:00'),
  (9, 3, 10, 'Yogurt Gloria Frutado 1kg', 2, 7.50, 15.00, '2025-12-05 11:15:00', '2025-12-05 11:15:00'),
  (10, 3, 12, 'Lay''s Clásicas 150g', 2, 4.50, 9.00, '2025-12-05 11:15:00', '2025-12-05 11:15:00'),
  (11, 3, 7, 'Azúcar Rubia Cartavio 1kg', 2, 4.20, 8.40, '2025-12-05 11:15:00', '2025-12-05 11:15:00');

INSERT INTO "sale_payment" ("id", "sale_id", "box_open_id", "payment_id", "payment_name", "amount", "created_at", "updated_at")
VALUES
  (3, 3, 2, 3, 'Yape', 50.00, '2025-12-05 11:16:00', '2025-12-05 11:16:00');

INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (17, '2025-12-05', 11, 'OUT', 3, 'venta', 'B001-00000002', 40, 39, 0, 18.90, 14.50, 565.50, '2025-12-05 11:17:00', '2025-12-05 11:17:00'),
  (18, '2025-12-05', 10, 'OUT', 3, 'venta', 'B001-00000002', 50, 48, 0, 7.50, 5.90, 283.20, '2025-12-05 11:17:00', '2025-12-05 11:17:00'),
  (19, '2025-12-05', 12, 'OUT', 3, 'venta', 'B001-00000002', 80, 78, 0, 4.50, 3.20, 249.60, '2025-12-05 11:17:00', '2025-12-05 11:17:00'),
  (20, '2025-12-05', 7, 'OUT', 3, 'venta', 'B001-00000002', 180, 178, 0, 4.20, 3.40, 605.20, '2025-12-05 11:17:00', '2025-12-05 11:17:00');

-- Venta 4 (Enero 2026)
INSERT INTO "sale" ("id", "serie", "box_open_id", "type_code", "user_id", "sale_date", "customer_id", "customer_name", "customer_doc_code", "customer_doc_number", "igv_rate", "taxable_amount", "igv_total", "total", "paid_amount", "change_amount", "is_return", "created_at", "updated_at")
VALUES
  (4, 'B001-00000003', 3, '03', 4, '2026-01-10 16:20:00', 6, 'Sofía Isabel Chávez Torres', '01', '75891234', 18.00, 67.80, 12.20, 80.00, 100.00, 20.00, false, '2026-01-10 16:20:00', '2026-01-10 16:20:00');

INSERT INTO "detail_sale" ("id", "sale_id", "product_id", "product_name", "qty", "price", "subtotal", "created_at", "updated_at")
VALUES
  (12, 4, 17, 'Papel Higiénico Suave 4 rollos', 3, 8.50, 25.50, '2026-01-10 16:20:00', '2026-01-10 16:20:00'),
  (13, 4, 18, 'Detergente Ace 1kg', 2, 11.90, 23.80, '2026-01-10 16:20:00', '2026-01-10 16:20:00'),
  (14, 4, 15, 'Jabón Protex 110g', 4, 3.80, 15.20, '2026-01-10 16:20:00', '2026-01-10 16:20:00'),
  (15, 4, 16, 'Pasta Dental Colgate 90g', 2, 5.90, 11.80, '2026-01-10 16:20:00', '2026-01-10 16:20:00'),
  (16, 4, 19, 'Cloro Sapolio 1L', 1, 4.20, 4.20, '2026-01-10 16:20:00', '2026-01-10 16:20:00');

INSERT INTO "sale_payment" ("id", "sale_id", "box_open_id", "payment_id", "payment_name", "amount", "created_at", "updated_at")
VALUES
  (4, 4, 3, 1, 'Efectivo', 100.00, '2026-01-10 16:21:00', '2026-01-10 16:21:00');

INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (21, '2026-01-10', 17, 'OUT', 4, 'venta', 'B001-00000003', 50, 47, 0, 8.50, 6.20, 291.40, '2026-01-10 16:22:00', '2026-01-10 16:22:00'),
  (22, '2026-01-10', 18, 'OUT', 4, 'venta', 'B001-00000003', 40, 38, 0, 11.90, 8.90, 338.20, '2026-01-10 16:22:00', '2026-01-10 16:22:00'),
  (23, '2026-01-10', 15, 'OUT', 4, 'venta', 'B001-00000003', 90, 86, 0, 3.80, 2.80, 240.80, '2026-01-10 16:22:00', '2026-01-10 16:22:00'),
  (24, '2026-01-10', 16, 'OUT', 4, 'venta', 'B001-00000003', 60, 58, 0, 5.90, 4.50, 261.00, '2026-01-10 16:22:00', '2026-01-10 16:22:00'),
  (25, '2026-01-10', 19, 'OUT', 4, 'venta', 'B001-00000003', 70, 69, 0, 4.20, 3.10, 213.90, '2026-01-10 16:22:00', '2026-01-10 16:22:00');

-- -----------------------------------------------------------------------------
-- 14. CIERRES DE CAJA (box_closed) - ejemplo para la primera caja
-- -----------------------------------------------------------------------------
INSERT INTO "box_closed" ("id", "serie", "user_id", "box_open_id", "start_date", "end_date", "status", "notes", "created_at", "updated_at")
VALUES
  (1, 'CIERRE-2025-1101', 2, 1, '2025-11-15 08:00:00', '2025-11-15 22:05:00', 'cerrado', 'Cierre normal sin diferencias', '2025-11-15 22:05:00', '2025-11-15 22:05:00');

INSERT INTO "detail_box_closed" ("id", "box_closed_id", "mode_payment", "mode_payment_name", "opening_amount", "expected_amount", "closing_amount", "difference_amount", "created_at", "updated_at")
VALUES
  (1, 1, 1, 'Efectivo', 200.00, 230.00, 230.00, 0.00, '2025-11-15 22:06:00', '2025-11-15 22:06:00'),
  (2, 1, 2, 'Tarjeta de Crédito', 0.00, 180.00, 180.00, 0.00, '2025-11-15 22:06:00', '2025-11-15 22:06:00'),
  (3, 1, 3, 'Yape', 0.00, 0.00, 0.00, 0.00, '2025-11-15 22:06:00', '2025-11-15 22:06:00');

-- -----------------------------------------------------------------------------
-- 15. AJUSTE DE STOCK (merma por vencimiento)
-- -----------------------------------------------------------------------------
INSERT INTO "stock_adjustment" ("id", "serie", "user_id", "stock_adjustment_date", "reason_id", "reason_name", "direction", "notes", "status", "total_qty", "total_value", "created_at", "updated_at")
VALUES
  (1, 'AJ-2026-0001', 3, '2026-02-20 10:00:00', 1, 'EXPIRY', 'Out', 'Yogurt próximo a vencer - se retira del stock', 'confirmado', 5, 29.50, '2026-02-20 10:00:00', '2026-02-20 10:15:00');

INSERT INTO "detail_stock_adjustment" ("id", "stock_adjustment_id", "product_id", "product_name", "qty", "valuation_rate", "subtotal", "created_at", "updated_at")
VALUES
  (1, 1, 10, 'Yogurt Gloria Frutado 1kg', 5, 5.90, 29.50, '2026-02-20 10:05:00', '2026-02-20 10:15:00');

INSERT INTO "kardex" ("id", "kardex_date", "product_id", "type", "doc_id", "doc_type", "doc_serie", "actual_qty", "after_qty", "incoming_rate", "outgoing_rate", "valuation_rate", "stock_value", "created_at", "updated_at")
VALUES
  (26, '2026-02-20', 10, 'OUT', 1, 'merma', 'AJ-2026-0001', 48, 43, 0, 0, 5.90, 253.70, '2026-02-20 10:16:00', '2026-02-20 10:16:00');

-- -----------------------------------------------------------------------------
-- 16. ACTUALIZACIÓN FINAL DE STOCK (refleja todos los movimientos)
-- -----------------------------------------------------------------------------
UPDATE "product_stock" SET stock = 238, stock_value = 999.60, updated_at = '2026-03-08 12:00:00' WHERE product_id = 1;
UPDATE "product_stock" SET stock = 200, stock_value = 820.00, updated_at = '2026-03-08 12:00:00' WHERE product_id = 2;
UPDATE "product_stock" SET stock = 395, stock_value = 335.75, updated_at = '2026-03-08 12:00:00' WHERE product_id = 3;
UPDATE "product_stock" SET stock = 178, stock_value = 320.40, updated_at = '2026-03-08 12:00:00' WHERE product_id = 4;
UPDATE "product_stock" SET stock = 96, stock_value = 1776.00, updated_at = '2026-03-08 12:00:00' WHERE product_id = 5;
UPDATE "product_stock" SET stock = 144, stock_value = 1123.20, updated_at = '2026-03-08 12:00:00' WHERE product_id = 6;
UPDATE "product_stock" SET stock = 178, stock_value = 605.20, updated_at = '2026-03-08 12:00:00' WHERE product_id = 7;
UPDATE "product_stock" SET stock = 250, stock_value = 525.00, updated_at = '2026-03-08 12:00:00' WHERE product_id = 8;
UPDATE "product_stock" SET stock = 155, stock_value = 713.00, updated_at = '2026-03-08 12:00:00' WHERE product_id = 9;
UPDATE "product_stock" SET stock = 43, stock_value = 253.70, updated_at = '2026-03-08 12:00:00' WHERE product_id = 10;
UPDATE "product_stock" SET stock = 39, stock_value = 565.50, updated_at = '2026-03-08 12:00:00' WHERE product_id = 11;
UPDATE "product_stock" SET stock = 78, stock_value = 249.60, updated_at = '2026-03-08 12:00:00' WHERE product_id = 12;
UPDATE "product_stock" SET stock = 98, stock_value = 235.20, updated_at = '2026-03-08 12:00:00' WHERE product_id = 13;
UPDATE "product_stock" SET stock = 196, stock_value = 215.60, updated_at = '2026-03-08 12:00:00' WHERE product_id = 14;
UPDATE "product_stock" SET stock = 86, stock_value = 240.80, updated_at = '2026-03-08 12:00:00' WHERE product_id = 15;
UPDATE "product_stock" SET stock = 58, stock_value = 261.00, updated_at = '2026-03-08 12:00:00' WHERE product_id = 16;
UPDATE "product_stock" SET stock = 47, stock_value = 291.40, updated_at = '2026-03-08 12:00:00' WHERE product_id = 17;
UPDATE "product_stock" SET stock = 38, stock_value = 338.20, updated_at = '2026-03-08 12:00:00' WHERE product_id = 18;
UPDATE "product_stock" SET stock = 69, stock_value = 213.90, updated_at = '2026-03-08 12:00:00' WHERE product_id = 19;
UPDATE "product_stock" SET stock = 60, stock_value = 288.00, updated_at = '2026-03-08 12:00:00' WHERE product_id = 20;

-- Ajuste de secuencias (importante para que los próximos INSERT no fallen por PK)
SELECT setval(pg_get_serial_sequence('"role"', 'id'), (SELECT MAX(id) FROM "role"));
SELECT setval(pg_get_serial_sequence('"user"', 'id'), (SELECT MAX(id) FROM "user"));
SELECT setval(pg_get_serial_sequence('"user_role"', 'id'), (SELECT MAX(id) FROM "user_role"));
SELECT setval(pg_get_serial_sequence('"category"', 'id'), (SELECT MAX(id) FROM "category"));
SELECT setval(pg_get_serial_sequence('"supplier"', 'id'), (SELECT MAX(id) FROM "supplier"));
SELECT setval(pg_get_serial_sequence('"customer"', 'id'), (SELECT MAX(id) FROM "customer"));
SELECT setval(pg_get_serial_sequence('"product"', 'id'), (SELECT MAX(id) FROM "product"));
SELECT setval(pg_get_serial_sequence('"product_price"', 'id'), (SELECT MAX(id) FROM "product_price"));
SELECT setval(pg_get_serial_sequence('"product_stock"', 'id'), (SELECT MAX(id) FROM "product_stock"));
SELECT setval(pg_get_serial_sequence('"order_purchase"', 'id'), (SELECT MAX(id) FROM "order_purchase"));
SELECT setval(pg_get_serial_sequence('"detail_order_purchase"', 'id'), (SELECT MAX(id) FROM "detail_order_purchase"));
SELECT setval(pg_get_serial_sequence('"receipt_purchase"', 'id'), (SELECT MAX(id) FROM "receipt_purchase"));
SELECT setval(pg_get_serial_sequence('"detail_receipt_purchase"', 'id'), (SELECT MAX(id) FROM "detail_receipt_purchase"));
SELECT setval(pg_get_serial_sequence('"kardex"', 'id'), (SELECT MAX(id) FROM "kardex"));
SELECT setval(pg_get_serial_sequence('"box_open"', 'id'), (SELECT MAX(id) FROM "box_open"));
SELECT setval(pg_get_serial_sequence('"detail_box_open"', 'id'), (SELECT MAX(id) FROM "detail_box_open"));
SELECT setval(pg_get_serial_sequence('"box_closed"', 'id'), (SELECT MAX(id) FROM "box_closed"));
SELECT setval(pg_get_serial_sequence('"detail_box_closed"', 'id'), (SELECT MAX(id) FROM "detail_box_closed"));
SELECT setval(pg_get_serial_sequence('"sale"', 'id'), (SELECT MAX(id) FROM "sale"));
SELECT setval(pg_get_serial_sequence('"detail_sale"', 'id'), (SELECT MAX(id) FROM "detail_sale"));
SELECT setval(pg_get_serial_sequence('"sale_payment"', 'id'), (SELECT MAX(id) FROM "sale_payment"));
SELECT setval(pg_get_serial_sequence('"stock_adjustment"', 'id'), (SELECT MAX(id) FROM "stock_adjustment"));
SELECT setval(pg_get_serial_sequence('"detail_stock_adjustment"', 'id'), (SELECT MAX(id) FROM "detail_stock_adjustment"));

COMMIT;
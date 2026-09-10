-- Datos iniciales de tipos de documento de venta
INSERT INTO "type_document_sale" ("id", "code", "name", "status", "created_at", "updated_at")
VALUES
  ('01','01', 'FACTURA', true, NOW(), NOW()),
  ('03','03', 'BOLETA DE VENTA', true, NOW(), NOW()),
  ('07','07', 'NOTA DE CRÉDITO', true, NOW(), NOW());
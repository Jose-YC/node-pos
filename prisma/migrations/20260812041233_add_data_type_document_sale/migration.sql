-- Datos iniciales de tipos de documento de venta
INSERT INTO "type_document_sale" ("id", "code", "name", "short_name", "status", "created_at", "updated_at")
VALUES
  ('01','01', 'FACTURA ELECTRÓNICA', 'FAC', true, NOW(), NOW()),
  ('03','03', 'BOLETA DE VENTA ELECTRÓNICA', 'BOL', true, NOW(), NOW()),
  ('07','07', 'NOTA DE CRÉDITO ELECTRÓNICA', 'NC', true, NOW(), NOW()),
  ('08','08', 'NOTA DE DÉBITO ELECTRÓNICA', 'ND', true, NOW(), NOW());   
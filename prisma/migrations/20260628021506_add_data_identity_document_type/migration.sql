-- Insertar tipos de documento de identidad 
INSERT INTO "identity_document_type" ("id", "code", "name", "short_name", "status", "created_at", "updated_at")
VALUES
  ('01', '01', 'DOCUMENTO NACIONAL DE IDENTIDAD', 'DNI', true, NOW(), NOW()),
  ('04', '04', 'CARNET DE EXTRANJERÍA', 'CE', true, NOW(), NOW()),
  ('06', '06', 'REGUISTRO ÚNICO DE CONTRIBUYENTES', 'RUC', true, NOW(), NOW()),
  ('07', '07', 'PASAPORTE', 'PAS', true, NOW(), NOW()),
  ('00', '00', 'SIN DOCUMENTO', 'S/D', true, NOW(), NOW());
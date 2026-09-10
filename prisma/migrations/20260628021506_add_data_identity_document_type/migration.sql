-- Insertar tipos de documento de identidad 
INSERT INTO "identity_document_type" ("id", "code", "name", "short_name", "created_at", "updated_at")
VALUES
  ('01', '01', 'DOC. NACIONAL DE IDENTIDAD', 'DNI', NOW(), NOW()),
  ('04', '04', 'CARNET DE EXTRANJERÍA', 'CE', NOW(), NOW()),
  ('06', '06', 'RUC', 'RUC', NOW(), NOW()),
  ('07', '07', 'PASAPORTE', 'PAS', NOW(), NOW());
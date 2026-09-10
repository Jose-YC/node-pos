INSERT INTO "customer" (
    "doc_type_code",
    "doc_type_name",
    "doc_type_number",
    "name",
    "is_generic",
    "updated_at"
)
SELECT
    '01',
    'DNI',
    '00000000',
    'CLIENTES VARIOS',
    true,
    NOW()
WHERE NOT EXISTS (
    SELECT 1
    FROM "customer"
    WHERE "is_generic" = true
);
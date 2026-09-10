-- This is an empty migration.

CREATE OR REPLACE FUNCTION fc_ListSuppliers(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          INTEGER,
    name        TEXT,
    type        TEXT,   
    ruc         TEXT,      
    email       TEXT,     
    phone       TEXT      
)
LANGUAGE sql
AS $$
    SELECT
        S.id,                   
        S.name,
        S.type,
        S.ruc,
        S.email,
        S.phone
    FROM "supplier" AS S
    WHERE
        S.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR S.name ILIKE '%' || p_search || '%' 
            OR S.ruc ILIKE '%' || p_search || '%' 
        )
    GROUP BY S.id, S.name, S.type, S.ruc, S.email, S.phone, S.created_at
    ORDER BY S.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListSuppliers(
    p_search    TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "supplier" AS S
	WHERE S.deleted_at IS NULL
	AND ( 
        p_search IS NULL 
        OR S.name ILIKE '%' || p_search || '%' 
        OR S.ruc ILIKE '%' || p_search || '%' 
    )
$$;
-- This is an empty migration.

CREATE OR REPLACE FUNCTION fc_ListCategorys(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          INTEGER,
    name        VARCHAR(100),
    description TEXT      
)
LANGUAGE sql
AS $$
    SELECT
        C.id,                   
        C.name,
        C.description
    FROM "category" AS C
    WHERE
        C.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR C.name ILIKE '%' || p_search || '%' 
        )
    GROUP BY C.id, C.name, C.description, C.created_at
    ORDER BY C.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_ListOptionsCategory(
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          INTEGER,
    name        VARCHAR(100)  
)
LANGUAGE sql
AS $$
    SELECT
        C.id,                   
        C.name
    FROM category AS C
    WHERE
        C.deleted_at IS NULL
        AND ( p_search IS NULL OR C.name ILIKE '%' || p_search || '%' )
    ORDER BY C.name ASC, C.id ASC
    LIMIT  p_limit;
$$;

CREATE OR REPLACE FUNCTION fc_CountListCategorys(
    p_search    TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "category" AS C
	WHERE C.deleted_at IS NULL
	AND ( 
        p_search IS NULL 
        OR C.name ILIKE '%' || p_search || '%'
    )
$$;
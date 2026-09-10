-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListCustomers(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id               INTEGER,
    name             TEXT,
    doc_type_code    TEXT,      
    doc_type_name    TEXT,        
    doc_type_number  TEXT,        
    email            TEXT,      
    phone            TEXT      
)
LANGUAGE sql
AS $$
    SELECT
        C.id,                   
        C.name,
        C.doc_type_code,
        C.doc_type_name,
        C.doc_type_number,
        C.email,
        C.phone     
    FROM "customer" AS C
    WHERE
        C.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR C.name ILIKE '%' || p_search || '%' 
            OR C.doc_type_number ILIKE '%' || p_search || '%' 
        )
    GROUP BY C.id, C.name, C.doc_type_code, C.doc_type_name, C.doc_type_number, C.email, C.phone, C.created_at
    ORDER BY C.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;     

CREATE OR REPLACE FUNCTION fc_CountListCustomers(
    p_search    TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "customer" AS C
	WHERE C.deleted_at IS NULL
	AND ( 
        p_search IS NULL 
        OR C.name ILIKE '%' || p_search || '%' 
        OR C.doc_type_number ILIKE '%' || p_search || '%' 
    )
$$;
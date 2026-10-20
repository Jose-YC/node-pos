CREATE OR REPLACE FUNCTION fc_ListTypeDocumentSales(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          VARCHAR(2),
    code        VARCHAR(2),
    name        VARCHAR(100),      
    short_name  VARCHAR(50),
    status      BOOLEAN
)
LANGUAGE sql
AS $$
    SELECT
        TDS.id,                   
        TDS.code,
        TDS.name,
        TDS.short_name,
        TDS.status
    FROM type_document_sale AS TDS
    WHERE
        TDS.deleted_at IS NULL
        AND ( p_search IS NULL OR TDS.name ILIKE '%' || p_search || '%' )
    ORDER BY TDS.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListTypeDocumentSales(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
        COUNT(*) AS total
    FROM type_document_sale AS TDS
    WHERE
        TDS.deleted_at IS NULL
        AND ( p_search IS NULL OR TDS.name ILIKE '%' || p_search || '%' )
$$;

CREATE OR REPLACE FUNCTION fc_ListOptionsTypeDocumentSales()
RETURNS TABLE (
    id          VARCHAR(2),
    name        VARCHAR(100)  
)
LANGUAGE sql
AS $$
    SELECT
        TDS.id,                   
        TDS.short_name AS name
    FROM type_document_sale AS TDS
    WHERE TDS.deleted_at IS NULL AND TDS.status = TRUE
    ORDER BY TDS.name ASC, id ASC;
$$;

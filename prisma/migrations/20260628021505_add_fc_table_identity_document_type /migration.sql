CREATE OR REPLACE FUNCTION fc_ListIdentityDocumentTypes(
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
        IDS.id,                   
        IDS.code,
        IDS.name,
        IDS.short_name,
        IDS.status
    FROM identity_document_type AS IDS
    WHERE
        IDS.deleted_at IS NULL
        AND ( p_search IS NULL OR IDS.name ILIKE '%' || p_search || '%' )
    ORDER BY IDS.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListIdentityDocumentTypes(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
        COUNT(*) AS total
    FROM type_document_sale AS IDS
    WHERE
        IDS.deleted_at IS NULL
        AND ( p_search IS NULL OR IDS.name ILIKE '%' || p_search || '%' )
$$;

CREATE OR REPLACE FUNCTION fc_ListOptionsIdentityDocumentTypes()
RETURNS TABLE (
    id          VARCHAR(2),
    name        VARCHAR(100)  
)
LANGUAGE sql
AS $$
    SELECT
        IDS.id,                   
        IDS.short_name AS name
    FROM type_document_sale AS IDS
    WHERE IDS.deleted_at IS NULL AND IDS.status = TRUE
    ORDER BY IDS.name ASC, id ASC;
$$;
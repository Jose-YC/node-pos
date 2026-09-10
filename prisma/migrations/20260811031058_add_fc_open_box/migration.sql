-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListBoxs(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id            INTEGER,
    serie         TEXT,
    status        TEXT,      
    start_date    TIMESTAMP,      
    end_date      TIMESTAMP     
)
LANGUAGE sql
AS $$
    SELECT
        BO.id,                   
        BO.serie,
        BO.status,
        BO.start_date,
        BO.end_date
    FROM "box_open" AS BO
    WHERE
        BO.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR BO.serie ILIKE '%' || p_search || '%' 
        )
    GROUP BY BO.id, BO.serie, BO.status, BO.start_date, BO.end_date, BO.created_at
    ORDER BY BO.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;     

CREATE OR REPLACE FUNCTION fc_CountListBoxs(
    p_search    TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "box_open" AS BO
	WHERE BO.deleted_at IS NULL
	AND ( 
        p_search IS NULL 
        OR BO.serie ILIKE '%' || p_search || '%' 
    );
$$;
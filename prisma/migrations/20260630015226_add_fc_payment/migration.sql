-- This is an empty migration.

CREATE OR REPLACE FUNCTION fc_ListPayments(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          INTEGER,
    name        VARCHAR(100),
    type        TEXT,
    status      BOOLEAN      
)
LANGUAGE sql
AS $$
    SELECT
        P.id,                   
        P.name,
        P.type,
        P.status
    FROM "payment" AS P
    WHERE
        P.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR P.name ILIKE '%' || p_search || '%' 
        )
    GROUP BY P.id, P.name, P.type, P.created_at
    ORDER BY P.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_ListOptionsPayments(
   p_limit        INTEGER,
   p_search     TEXT DEFAULT NULL
)
RETURNS TABLE (
    id INTEGER,
    name TEXT
) 
LANGUAGE sql
AS $$
	SELECT
	    id,
	    name
	FROM payment
	WHERE deleted_at IS NULL
	AND (
		p_search IS NULL 
		OR name ILIKE '%' || p_search || '%'
	)
	ORDER BY name ASC, id ASC
	LIMIT p_limit;
$$;

CREATE OR REPLACE FUNCTION fc_CountListPayments(
    p_search    TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "payment" AS P
	WHERE P.deleted_at IS NULL
	AND ( 
        p_search IS NULL 
        OR P.name ILIKE '%' || p_search || '%'
        OR P.type ILIKE '%' || p_search || '%'
    )
$$;     
CREATE OR REPLACE FUNCTION fc_ListRoles(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          INTEGER,
    name        VARCHAR(100),
    description TEXT,           
    permissions INTEGER          
)
LANGUAGE sql
AS $$
    SELECT
        R.id,                   
        R.name,
        R.description,
        COUNT(RP.permission_id) AS permissions
    FROM role AS R
    LEFT JOIN role_permission AS RP
        ON RP.role_id = R.id AND RP.deleted_at IS NULL
    WHERE
        R.deleted_at IS NULL
        AND ( p_search IS NULL OR R.name ILIKE '%' || p_search || '%' )
    GROUP BY R.id, R.name, R.description, R.created_at
    ORDER BY R.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListRoles(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM role
	WHERE deleted_at IS NULL
	AND ( p_search IS NULL OR name ILIKE '%' || p_search || '%' )
$$;


CREATE FUNCTION fc_RolById(
	p_rol_id	INTEGER
)
RETURNS TABLE (
    id             INTEGER,
    name           VARCHAR,
    description    TEXT,
    permissions  JSONB
)
LANGUAGE sql
AS $$
	SELECT 
	  r.id,
	  r.name,
	  r.description,
	  COALESCE(
        JSONB_AGG(JSON_BUILD_OBJECT('id', p.id, 'name', p.name, 'module', p.module))
          FILTER (WHERE p.id IS NOT NULL),
        '[]'::JSONB
      )
	FROM role r
	LEFT JOIN role_permission rp ON r.id = rp.role_id
	LEFT JOIN permission p ON p.id = rp.permission_id
	WHERE r.id = p_rol_id AND r.deleted_at IS NULL
	GROUP BY r.id, r.name, r.description;
$$;

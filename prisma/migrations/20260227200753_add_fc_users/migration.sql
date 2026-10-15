CREATE OR REPLACE FUNCTION fc_ListUsers(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          INTEGER,
    name        VARCHAR(100),
    email       TEXT,
    image_url   TEXT
    -- roles INTEGER          
)
LANGUAGE sql
AS $$
    SELECT
        U.id,                   
        U.name,
        U.email,
        U.image_url
    FROM "user" AS U
    WHERE
        U.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR U.name ILIKE '%' || p_search || '%' 
            OR U.email ILIKE '%' || p_search || '%'
        )
    GROUP BY U.id, U.name, U.email, U.created_at
    ORDER BY U.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListUsers(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "user" AS U
	WHERE U.deleted_at IS NULL
	AND ( 
        p_search IS NULL 
        OR U.name ILIKE '%' || p_search || '%'
        OR U.email ILIKE '%' || p_search || '%' 
    );
$$;


CREATE OR REPLACE FUNCTION fc_UserById(
	p_user_id	INTEGER
)
RETURNS TABLE (
    id             	INTEGER,
    name           	VARCHAR,
    email    	   	TEXT,
    image_url      	TEXT,
    roles  			JSONB
)
LANGUAGE sql
ROWS 1
AS $$
	SELECT 
	  u.id,
	  u.name,
	  u.email,
      u.image_url,
	  COALESCE(
        JSONB_AGG(JSON_BUILD_OBJECT('id', r.id, 'name', r.name))
          FILTER (WHERE r.id IS NOT NULL),
        '[]'::JSONB
      )	AS roles
	FROM "user" u
	LEFT JOIN user_role ur ON u.id = ur.user_id AND ur.deleted_at IS NULL
	LEFT JOIN role r ON r.id = ur.role_id
	WHERE u.id = p_user_id AND u.deleted_at IS NULL
	GROUP BY u.id, u.name, u.email;
$$;

CREATE OR REPLACE FUNCTION fc_UserPermissionsById(
	p_user_id	INTEGER
)
RETURNS TABLE (
    id             	INTEGER,
    permissions     TEXT[]
)
LANGUAGE sql
ROWS 1 	
AS $$
	SELECT 
	  u.id,
	  COALESCE(
        ARRAY_AGG(P.name) FILTER (WHERE P.id IS NOT NULL),
        ARRAY[]::TEXT[]
      )	AS permissions
    FROM "user" u
	LEFT JOIN user_role AS UR ON U.id = UR.user_id AND UR.deleted_at IS NULL
    LEFT JOIN role AS R ON UR.role_id = R.id AND R.deleted_at IS NULL
    LEFT JOIN role_permission AS RP ON R.id = RP.role_id AND RP.deleted_at IS NULL
    LEFT JOIN permission AS P ON RP.permission_id = P.id AND P.deleted_at IS NULL
    WHERE U.id =  p_user_id AND U.deleted_at IS NULL
	GROUP BY u.id;
$$;
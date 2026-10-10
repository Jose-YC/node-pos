-- funcion para listar permisos.  
CREATE OR REPLACE FUNCTION fc_ListPermissions(
   page       INTEGER,
   lim        INTEGER,
   search     TEXT DEFAULT NULL
)
RETURNS TABLE (
    id INTEGER,
    name TEXT,
    module TEXT
) 
LANGUAGE sql
AS $$
	SELECT
	    id,
	    name,
	    module
	FROM permission
	WHERE deleted_at IS NULL
	AND (
		search IS NULL 
		OR name ILIKE '%' || search || '%'
		OR module ILIKE '%' || search || '%'
	)
	GROUP BY id, name, module
	ORDER BY created_at DESC
	LIMIT lim
	OFFSET (page - 1) * lim;
$$;

-- funcion para dar el total de permisos.  
CREATE OR REPLACE FUNCTION fc_CountListPermissions(
   search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM permission
	WHERE deleted_at IS NULL
	AND (
		search IS NULL 
		OR name ILIKE '%' || search || '%'
		OR module ILIKE '%' || search || '%'
	)
$$;
CREATE OR REPLACE PROCEDURE sp_CreateRol(
    role_name VARCHAR(100),
    role_description TEXT,
    permissions_ids INTEGER[]
)
LANGUAGE plpgsql
AS $$
DECLARE 
    rol_id INTEGER;
BEGIN
    IF EXISTS (SELECT 1 FROM role WHERE name = role_name) THEN
        RAISE EXCEPTION 'El nombre del rol ya existe';
    END IF;
    
    INSERT INTO role ("name", "description", "updated_at") 
    VALUES (role_name, role_description, NOW()) 
    RETURNING id INTO rol_id;

    CREATE TEMP TABLE temp_permission ON COMMIT DROP AS
    SELECT UNNEST(permissions_ids) AS p_id;

    IF EXISTS (
        SELECT 1 FROM temp_permission TP
        LEFT JOIN permission P ON TP.p_id = P.id AND P.deleted_at IS NULL
        WHERE P.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Uno o más permisos no existen o están eliminados.';
    END IF;

    INSERT INTO role_permission ("role_id", "permission_id")
    SELECT rol_id, p_id FROM temp_permission;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE; 
END
$$;


CREATE OR REPLACE PROCEDURE sp_UpdateRol(
    p_role_id INTEGER,
    p_role_name VARCHAR(100) DEFAULT NULL,
    p_role_description TEXT DEFAULT NULL,
    p_permissions_ids INTEGER[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS ( SELECT 1 FROM role WHERE id =  p_role_id AND deleted_at IS NULL ) THEN
        RAISE EXCEPTION 'El rol a modificar no existe o esta eliminado.';
    END IF;

    IF p_role_name IS NOT NULL THEN
        IF EXISTS (
            SELECT 1 FROM role 
            WHERE name = p_role_name 
            AND id != p_role_id 
        ) THEN
            RAISE EXCEPTION 'El nombre del rol ya existe.';
        END IF;
    END IF;

    IF (p_role_name IS NOT NULL OR p_role_description IS NOT NULL)
    THEN
		UPDATE role
        SET
            name = COALESCE(p_role_name, name),
            description = COALESCE(p_role_description, description),
            updated_at = NOW()
        WHERE id = p_role_id;
    END IF;

    IF (p_permissions_ids IS NOT NULL)
    THEN
        CREATE TEMP TABLE temp_permission ON COMMIT DROP AS
        SELECT UNNEST(p_permissions_ids) AS id;

        IF EXISTS (
            SELECT 1 FROM temp_permission AS TP
            LEFT JOIN permission AS P ON TP.id = P.id AND P.deleted_at IS NULL
            WHERE P.id IS NULL
        ) THEN
            RAISE EXCEPTION 'Uno o más permisos no existen o están eliminados.';
        END IF;

        -- CASO A: Soft-delete de permisos que ya no están en la lista
        UPDATE role_permission AS rp    
		SET 
            deleted_at = NOW()
        WHERE rp.role_id = p_role_id
        AND rp.deleted_at  IS NULL
        AND NOT EXISTS (
            SELECT 1 FROM temp_permission TP
            WHERE TP.id = rp.permission_id
        );


        -- CASO B: Restaurar permisos soft-deleted que vuelven a la lista
        UPDATE role_permission AS rp   
		SET 
            deleted_at = NULL
        FROM temp_permission AS TP
        WHERE TP.id          = rp.permission_id
          AND rp.role_id     = p_role_id
          AND rp.deleted_at IS NOT NULL;


        -- CASO C: Insertar solo los que realmente no existen
        INSERT INTO role_permission ("role_id", "permission_id", "created_at")
        SELECT p_role_id, TP.id, NOW()
        FROM temp_permission AS TP
        WHERE NOT EXISTS (
            SELECT 1 FROM role_permission AS RP
            WHERE RP.role_id      = p_role_id
            AND RP.permission_id = TP.id
        );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE; 
END
$$;
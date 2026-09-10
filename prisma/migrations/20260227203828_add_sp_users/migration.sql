CREATE OR REPLACE PROCEDURE sp_CreateUser(
    p_user_name VARCHAR(30),
    p_user_email VARCHAR(255),
    p_user_password VARCHAR(255),
    p_roles_ids INTEGER[]
)
LANGUAGE plpgsql
AS $$
DECLARE 
    p_user_id INTEGER;
BEGIN
    IF EXISTS (
        SELECT 1 FROM "user" WHERE email =  p_user_email 
    ) THEN 
        RAISE EXCEPTION 'El email del usuario ya existe y no puedes duplicarlo.';
    END IF;

    INSERT INTO "user" ("name", "email", "password", "updated_at") 
    VALUES (p_user_name, p_user_email, p_user_password, NOW()) 
    RETURNING id INTO p_user_id;

    CREATE TEMP TABLE temp_roles ON COMMIT DROP AS
    SELECT UNNEST(p_roles_ids) AS p_id;

     IF EXISTS (
        SELECT 1 FROM temp_roles TP
        LEFT JOIN role R ON TP.p_id = R.id AND R.deleted_at IS NULL
        WHERE R.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Uno o más roles no existen o están eliminados.';
    END IF;

    INSERT INTO user_role ("user_id", "role_id")
    SELECT p_user_id, p_id FROM temp_roles;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE; 
END
$$;

CREATE OR REPLACE PROCEDURE sp_UpdateUser(
    p_user_id INTEGER,
    p_user_name VARCHAR(30) DEFAULT NULL,
    p_user_email VARCHAR(255) DEFAULT NULL,
    p_user_password VARCHAR(255) DEFAULT NULL,
    p_roles_ids INTEGER[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM "user" WHERE id = p_user_id AND deleted_at IS NULL
    ) THEN 
        RAISE EXCEPTION 'El usuario no existe o está eliminado.';
    END IF;
    
    IF ( p_user_email IS NOT NULL ) THEN
        IF EXISTS (
            SELECT 1 FROM "user" 
            WHERE email =  p_user_email 
            AND id != p_user_id
        ) THEN 
            RAISE EXCEPTION 'El email del usuario ya existe y no puedes duplicarlo.';
        END IF;
    END IF;

    IF(p_user_name IS NOT NULL OR p_user_password IS NOT NULL OR p_user_email IS NOT NULL) THEN
        UPDATE "user"
        SET
            name = COALESCE(p_user_name, name),
            email = COALESCE(p_user_email, email),
            password = COALESCE(p_user_password, password),
            updated_at = NOW()
        WHERE id = p_user_id;
    END IF;

    IF (p_roles_ids IS NOT NULL) THEN
        CREATE TEMP TABLE temp_roles ON COMMIT DROP AS
        SELECT UNNEST(p_roles_ids) AS id;

        IF EXISTS (
            SELECT 1 FROM temp_roles TP
            LEFT JOIN role R ON TP.id = R.id AND R.deleted_at IS NULL
            WHERE R.id IS NULL
        ) THEN
            RAISE EXCEPTION 'Uno o más roles no existen o están eliminados.';
        END IF;

        -- CASO A: Soft-delete de roles que ya no están en la lista
        UPDATE user_role AS ur    
		SET 
            deleted_at = NOW()
        WHERE ur.user_id = p_user_id
        AND ur.deleted_at  IS NULL
        AND NOT EXISTS (
            SELECT 1 FROM temp_roles TR
            WHERE TR.id = ur.role_id
        );


        -- CASO B: Restaurar roles soft-deleted que vuelven a la lista
        UPDATE user_role AS ur   
		SET 
            deleted_at = NULL
        FROM temp_roles AS TR
        WHERE TR.id          = ur.role_id
          AND ur.user_id     = p_user_id
          AND ur.deleted_at IS NOT NULL;


        -- CASO C: Insertar solo los que realmente no existen
        INSERT INTO user_role ("user_id", "role_id", "created_at")
        SELECT p_user_id, TR.id, NOW()
        FROM temp_roles AS TR
        WHERE NOT EXISTS (
            SELECT 1 FROM user_role AS UR
            WHERE UR.user_id      = p_user_id
            AND UR.role_id = TR.id
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE; 
END
$$;

    

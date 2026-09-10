CREATE OR REPLACE FUNCTION fc_RegisterUser(
    p_user_email VARCHAR(100) DEFAULT NULL,
    p_user_name TEXT DEFAULT NULL,
    p_user_password TEXT DEFAULT NULL
)
RETURNS TABLE(id INTEGER, email VARCHAR, name TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    p_user_id INTEGER;
BEGIN
    IF EXISTS (SELECT 1 FROM "user" u WHERE u.email = p_user_email) THEN
        RAISE EXCEPTION 'El usuario a registrar ya existe.';
    END IF;

    INSERT INTO "user" ("email", "name", "password", "updated_at") 
    VALUES (p_user_email, p_user_name, p_user_password, NOW())
    RETURNING "user".id INTO p_user_id;

    INSERT INTO user_role ("user_id", "role_id")
    VALUES (p_user_id, 1); -- Asignar el rol "user" por defecto (id = 1)

    RETURN QUERY
    SELECT 
        p_user_id::INTEGER        AS id, 
        p_user_email::VARCHAR     AS email, 
        p_user_name::TEXT         AS name;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %', SQLERRM;
        RAISE; 
END
$$;
CREATE OR REPLACE PROCEDURE sp_CreateCustomer(
	p_name	TEXT,
	p_doc_type_code	TEXT,
	p_doc_type_number TEXT,
	p_email	TEXT DEFAULT NULL,
	p_phone	TEXT DEFAULT NULL
) 
LANGUAGE plpgsql
AS $$
DECLARE
	v_doc_type_name	TEXT;
BEGIN
    SELECT 
        IDT.short_name
    INTO
        v_doc_type_name
    FROM "identity_document_type" AS IDT
    WHERE IDT.id = p_doc_type_code;

    IF NOT FOUND THEN
		RAISE EXCEPTION 'El tipo documento de identidad no existe.';
	END IF;

    IF EXISTS (
        SELECT 1 
        FROM "customer" AS C
        WHERE C.doc_type_number = p_doc_type_number
    ) THEN
		RAISE EXCEPTION 'El cliente con este documento ya existe.';
    END IF;

    INSERT INTO "customer" (doc_type_code, doc_type_name, doc_type_number, name, email, phone, updated_at)
    VALUES (p_doc_type_code, v_doc_type_name, p_doc_type_number, p_name, p_email, p_phone, NOW());
END
$$;


CREATE OR REPLACE PROCEDURE sp_UpdateCustomer(
    p_customer_id INTEGER,
	p_name	TEXT DEFAULT NULL,
	p_doc_type_code	TEXT DEFAULT NULL,
	p_doc_type_number TEXT DEFAULT NULL,
	p_email	TEXT DEFAULT NULL,
	p_phone	TEXT DEFAULT NULL
) 
LANGUAGE plpgsql
AS $$
DECLARE
	v_doc_type_name	TEXT;
BEGIN

    IF NOT EXISTS (
        SELECT 1 
        FROM "customer" AS C
        WHERE C.id = p_customer_id
    ) THEN
		RAISE EXCEPTION 'El cliente a editar no existe.';
    END IF;

    IF p_doc_type_code IS NOT NULL AND p_doc_type_number IS NOT NULL THEN 
        SELECT 
            IDT.short_name
        INTO
            v_doc_type_name
        FROM "identity_document_type" AS IDT
        WHERE IDT.id = p_doc_type_code;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'El tipo documento de identidad no existe.';
        END IF;

        IF EXISTS (
            SELECT 1 
            FROM "customer" AS C
            WHERE C.doc_type_number = p_doc_type_number
        ) THEN
            RAISE EXCEPTION 'El cliente con este documento ya existe.';
        END IF;
    END IF;
    
    UPDATE "customer" AS C
    SET
        doc_type_code = COALESCE(p_doc_type_code, doc_type_code),
        doc_type_name = COALESCE(v_doc_type_name, doc_type_name),
        doc_type_number = COALESCE(p_doc_type_number, doc_type_number),
        name = COALESCE(p_name, name),
        email = COALESCE(p_email, email),
        phone = COALESCE(p_phone, phone),
        updated_at = NOW()
    WHERE C.id = p_customer_id;
END
$$;
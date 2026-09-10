-- This is an empty migration.
CREATE OR REPLACE PROCEDURE sp_OpenBox(
    p_userid		INTEGER,
    p_amount_cash   NUMERIC(12,2),
    p_notes         TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_serie TEXT;
    v_box_open_id INTEGER;
BEGIN
    IF EXISTS(
        SELECT 1 FROM "box_open" AS OB WHERE OB.status = 'abierto' AND OB.user_id = p_userid
    ) THEN
        RAISE EXCEPTION 'Ya tienes abierta una caja.';
    END IF;

    IF NOT EXISTS(
        SELECT 1 FROM "payment" AS P WHERE P.type = 'cash'
    ) THEN
        RAISE EXCEPTION 'No tienes un metodo de pago en efectivo.';
    END IF;

    v_serie := 'OPEN-' || p_userid::TEXT || '-' || LPAD(nextval('open_box_serie')::TEXT, 6, '0');

    INSERT INTO "box_open" (serie, user_id, start_date, end_date, status, notes, updated_at)
    VALUES (v_serie, p_userid, NOW(), NULL, 'abierto', p_notes, NOW())
    RETURNING id INTO v_box_open_id;

    INSERT INTO "detail_box_open" (box_open_id, mode_payment, opening_amount, updated_at)
    SELECT
        v_box_open_id,
        P.id,
        CASE WHEN P.type = 'cash' THEN p_amount_cash ELSE 0 END,
        NOW()
    FROM "payment" AS P;
END
$$
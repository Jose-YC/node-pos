-- This is an empty migration.
CREATE OR REPLACE PROCEDURE sp_ClosedBox(
	p_user_id		INTEGER,
	p_box_open_id	INTEGER,
	p_amount_cash   NUMERIC(12,2),
	p_notes         TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_box_closed_id			INTEGER;
	v_serie					TEXT;
	v_date_open				TIMESTAMP;
	v_total_change			NUMERIC(12,2);
BEGIN

	SELECT 
		start_date	
	INTO
		v_date_open
	FROM "box_open" AS BO 
	WHERE 
		BO.id = p_box_open_id AND 
		BO.status = 'abierto' AND 
		BO.user_id = p_user_id
	FOR UPDATE;

	IF NOT FOUND THEN 
	RAISE EXCEPTION 'No tienes abierta la caja seleccionada.';
	END IF;

	-- Vuelto total de la caja (solo afecta efectivo)
    SELECT 
		COALESCE(SUM(change_amount), 0)
    INTO   
		v_total_change
    FROM   "sale"
    WHERE  box_open_id = p_box_open_id
      AND  is_return   = false
      AND  deleted_at  IS NULL;
	
	-- Generar serie de caja cerrada
	v_serie := 'CLOSED-' || p_user_id::TEXT || '-' || LPAD(nextval('closed_box_serie')::TEXT, 6, '0');

	-- Insertar registro de caja cerrada
	INSERT INTO "box_closed"(serie, user_id, box_open_id, start_date, end_date, status, notes, updated_at)
	VALUES(v_serie, p_user_id, p_box_open_id, v_date_open, NOW(), 'cerrado', p_notes, NOW())
	RETURNING id INTO v_box_closed_id;

	-- Insertar detalle de caja cerrada por medio de pago
	INSERT INTO "detail_box_closed"(
		box_closed_id, 
		mode_payment, 
		mode_payment_name,	
		opening_amount, 
		expected_amount, 
		closing_amount, 
		difference_amount, 
		updated_at
	)
	WITH
		sales_by_payment AS (
			SELECT	
				SP.payment_id,
				SUM(SP.amount) AS total_sales
			FROM "sale" AS S
			INNER JOIN "sale_payment" AS SP ON S.id = SP.sale_id
			WHERE S.box_open_id = p_box_open_id AND S.is_return = false
			GROUP BY SP.payment_id
		),
		returns_by_payment AS (
			SELECT	
				SP.payment_id,
				SUM(SP.amount) AS total_returns
			FROM "sale" AS S
			INNER JOIN "sale_payment" AS SP ON S.id = SP.sale_id
			WHERE S.box_open_id = p_box_open_id AND S.is_return = true
			GROUP BY SP.payment_id
		)
	SELECT
		v_box_closed_id 							AS box_close_id,
		P.id										AS mode_payment,
		P.name										AS mode_payment_name,
		COALESCE(DBO.opening_amount, 0)             AS opening_amount,

		-- expected = opening + ventas - devoluciones - vuelto (solo cash)
		COALESCE(DBO.opening_amount, 0)
            + COALESCE(SBP.total_sales, 0)
            - COALESCE(RBP.total_returns, 0)
            - CASE WHEN P.type = 'cash' THEN v_total_change ELSE 0 END AS expected_amount,
		
		-- Solo el efectivo se cuenta físicamente, el resto de los medios de pago se asume que son correctos
		CASE
            WHEN P.type = 'cash' THEN p_amount_cash
            ELSE COALESCE(DBO.opening_amount, 0)
                 + COALESCE(SBP.total_sales, 0)
                 - COALESCE(RBP.total_returns, 0)
        END AS closing_amount,

		-- difference = closing - expected
		CASE
            WHEN P.type = 'cash' THEN p_amount_cash
            ELSE COALESCE(DBO.opening_amount, 0)
                 + COALESCE(SBP.total_sales, 0)
                 - COALESCE(RBP.total_returns, 0)
        END
		- (
            COALESCE(DBO.opening_amount, 0)
            + COALESCE(SBP.total_sales, 0)
            - COALESCE(RBP.total_returns, 0)
            - CASE WHEN P.type = 'cash' THEN v_total_change ELSE 0 END
          ) AS difference_amount,
		NOW() AS updated_at
	FROM "detail_box_open" AS DBO
    JOIN "payment" AS P ON P.id = DBO.mode_payment
    LEFT JOIN sales_by_payment AS SBP ON SBP.payment_id = DBO.mode_payment
    LEFT JOIN returns_by_payment AS RBP ON RBP.payment_id = DBO.mode_payment
    WHERE DBO.box_open_id = p_box_open_id;

	-- Actualizar estado de caja abierta a cerrado
	UPDATE "box_open"
    SET    status     = 'cerrado',
           end_date   = NOW(),
           updated_at = NOW()
    WHERE  id = p_box_open_id;
	
END
$$
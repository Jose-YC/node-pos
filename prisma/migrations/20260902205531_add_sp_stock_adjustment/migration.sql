-- This is an empty migration.
CREATE OR REPLACE PROCEDURE sp_CreateStockAdjustment(
    p_user_id INTEGER,
    p_reason_id INTEGER,
    p_items JSONB,
    p_notes TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_adjustment_id   INTEGER;
    v_serie                 TEXT;
    v_direction             TEXT;
    v_reason                TEXT;
    v_total_qty             NUMERIC(12,2);
    v_total_value           NUMERIC(12,2);
BEGIN
    SELECT 
        status,
        description
    INTO 
        v_direction,    
        v_reason
    FROM "reason" 
    WHERE id = p_reason_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'La razon seleccionada no esta permitica';
    END IF;

    CREATE TEMP TABLE tmp_items (
        product_id      INTEGER,
        product_name    TEXT,
        product_stock   NUMERIC(12,2),
        qty             INTEGER,
        valuation_rate  NUMERIC(12,2),
        subtotal        NUMERIC(12,2)
    ) ON COMMIT DROP;

    INSERT INTO tmp_items (product_id, product_name, product_stock, qty, valuation_rate, subtotal)
    SELECT
        P.id                            AS product_id,
        P.name                          AS product_name,
        PS.stock                        AS product_stock,
        i.qty                           AS qty,
        PS.valuation_rate               AS valuation_rate,
        (i.qty * PS.valuation_rate)     AS subtotal
    FROM jsonb_to_recordset(p_items) AS i( product_id INTEGER, qty INTEGER)
    LEFT JOIN "product" AS P ON P.id = i.product_id
    LEFT JOIN "product_stock" AS PS ON PS.product_id = P.id;

    IF EXISTS (SELECT 1 FROM tmp_items WHERE product_id IS NULL) THEN
        RAISE EXCEPTION 'Un producto o mas de los seleccionado no existe';
    END IF;

    IF v_direction = 'OUT' THEN
        IF EXISTS (SELECT 1 FROM tmp_items WHERE qty > product_stock) THEN
            RAISE EXCEPTION 'La cantidad a retirar de uno o mas productos es mayor a la cantidad disponible en stock';
        END IF;
    END IF;

    SELECT 
        SUM(qty), 
        SUM(subtotal) 
    INTO 
        v_total_qty, 
        v_total_value 
    FROM tmp_items;

    IF v_direction = 'OUT' THEN
        v_serie := 'MI-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(nextval('stock_adjustment_out_serie')::TEXT, 6, '0');
    ELSE
        v_serie := 'MA-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(nextval('stock_adjustment_in_serie')::TEXT, 6, '0');
    END IF;

    INSERT INTO "stock_adjustment" (user_id, serie, direction, stock_adjustment_date, reason_id, reason_name, notes, status, total_qty, total_value, updated_at)
    VALUES (p_user_id, v_serie, v_direction, NOW(), p_reason_id, v_reason, p_notes, 'borrador', v_total_qty, v_total_value, NOW())
    RETURNING id INTO v_stock_adjustment_id;

    INSERT INTO "detail_stock_adjustment" (stock_adjustment_id, product_id, product_name, qty, valuation_rate, subtotal, updated_at)
    SELECT
        v_stock_adjustment_id,
        product_id,
        product_name,
        qty,
        valuation_rate,
        subtotal,
        NOW()
    FROM tmp_items;
END
$$;

CREATE OR REPLACE PROCEDURE sp_UpdateStockAdjustment(
    p_stock_adjustment_id INTEGER,
    p_reason_id INTEGER DEFAULT NULL,
    p_items JSONB DEFAULT NULL,
    p_notes TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_direction             TEXT;
    v_reason                TEXT;
    v_total_qty             NUMERIC(12,2);
    v_total_value           NUMERIC(12,2);
BEGIN

    SELECT 
        direction,
        reason_name
    INTO 
        v_direction,
        v_reason
    FROM "stock_adjustment" 
    WHERE 
        id = p_stock_adjustment_id AND 
        status = 'borrador'
    FOR UPDATE;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El documento seleccionado no existe o no se encuentra en estado borrador';
    END IF;

    IF p_reason_id IS NOT NULL THEN
        SELECT
            description
        INTO
            v_reason
        FROM "reason"
        WHERE
            id = p_reason_id
            AND status = v_direction;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'La razon seleccionada no esta permitida para el tipo de ajuste seleccionado';
        END IF;

    END IF;

    IF p_items IS NOT NULL THEN
        CREATE TEMP TABLE tmp_items (
            product_id      INTEGER,
            product_name    TEXT,
            product_stock   NUMERIC(12,2),
            qty             INTEGER,
            valuation_rate  NUMERIC(12,2),
            subtotal        NUMERIC(12,2)
        ) ON COMMIT DROP;

        INSERT INTO tmp_items (product_id, product_name, product_stock, qty, valuation_rate, subtotal)
        SELECT
            P.id                            AS product_id,
            P.name                          AS product_name,
            PS.stock                        AS product_stock,
            i.qty                           AS qty,
            PS.valuation_rate               AS valuation_rate,
            (i.qty * PS.valuation_rate)     AS subtotal
        FROM jsonb_to_recordset(p_items) AS i( product_id INTEGER, qty INTEGER)
        LEFT JOIN "product" AS P ON P.id = i.product_id
        LEFT JOIN "product_stock" AS PS ON PS.product_id = P.id;

        IF EXISTS (SELECT 1 FROM tmp_items WHERE product_id IS NULL) THEN
            RAISE EXCEPTION 'Un producto o mas de los seleccionado no existe';
        END IF;

        IF v_direction = 'OUT' THEN
            IF EXISTS (SELECT 1 FROM tmp_items WHERE qty > product_stock) THEN
                RAISE EXCEPTION 'La cantidad a retirar de uno o mas productos es mayor a la cantidad disponible en stock';
            END IF;
        END IF;

        SELECT 
            SUM(qty), 
            SUM(subtotal) 
        INTO 
            v_total_qty, 
            v_total_value 
        FROM tmp_items;

        UPDATE "stock_adjustment"
        SET 
            total_qty = v_total_qty,
            total_value = v_total_value,
            updated_at = NOW()
        WHERE id = p_stock_adjustment_id;

        INSERT INTO "detail_stock_adjustment" ( stock_adjustment_id, product_id, product_name, qty, valuation_rate, subtotal, updated_at)
		SELECT
			p_stock_adjustment_id,
			TI.product_id,
			TI.product_name,
			TI.qty,
			TI.valuation_rate,
			TI.subtotal,
			NOW()
		FROM tmp_items AS TI
		WHERE NOT EXISTS (
			SELECT 1 FROM "detail_stock_adjustment" AS DMI 
			WHERE 
				DMI.stock_adjustment_id = p_stock_adjustment_id AND 
				DMI.product_id = TI.product_id
		);

		UPDATE "detail_stock_adjustment" AS DMI
		SET
			qty = TI.qty, 
			valuation_rate = TI.valuation_rate, 
			subtotal = TI.subtotal, 
			updated_at = NOW()
		FROM tmp_items AS TI
		WHERE 
			DMI.stock_adjustment_id = p_stock_adjustment_id AND 
			DMI.product_id = TI.product_id 
		AND(
			DMI.qty		IS DISTINCT FROM TI.qty OR
			DMI.valuation_rate	IS DISTINCT FROM TI.valuation_rate
		);

		DELETE FROM "detail_stock_adjustment" AS DMI
		WHERE 
			DMI.stock_adjustment_id = p_stock_adjustment_id 
			AND NOT EXISTS (
				SELECT 1 FROM tmp_items AS TI WHERE TI.product_id = DMI.product_id 
			);
    END IF;

    UPDATE "stock_adjustment"
    SET
        reason_id = COALESCE(p_reason_id, reason_id),
        reason_name = COALESCE(v_reason, reason_name),
        notes = COALESCE(p_notes, notes),
        total_qty = COALESCE(v_total_qty, total_qty),
        total_value = COALESCE(v_total_value, total_value),
        updated_at = NOW()
    WHERE id = p_stock_adjustment_id;
END
$$;

CREATE OR REPLACE PROCEDURE sp_ConfirmStockAdjustment(
    p_stock_adjustment_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_direction             TEXT;
    v_serie                 TEXT;
BEGIN
    SELECT 
        direction,
        serie
    INTO
        v_direction,
        v_serie
    FROM "stock_adjustment" 
    WHERE 
        id = p_stock_adjustment_id AND 
        status = 'borrador' 
    FOR UPDATE ;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El documento seleccionado no existe o no se encuentra en estado de borrador';
    END IF; 

    CREATE TEMP TABLE tmp_items (
        product_id      INTEGER,
        product_name    TEXT,
        product_stock   NUMERIC(12,2),
        qty             INTEGER,
        valuation_rate  NUMERIC(12,2),
        subtotal        NUMERIC(12,2)
    ) ON COMMIT DROP;

    INSERT INTO tmp_items (product_id, product_name, product_stock, qty, valuation_rate, subtotal)
    SELECT
        DMI.product_id,
        DMI.product_name,
        PS.stock,
        DMI.qty,
        PS.valuation_rate,
        (DMI.qty * PS.valuation_rate) AS subtotal
    FROM "detail_stock_adjustment" AS DMI
    JOIN "product_stock" AS PS ON PS.product_id = DMI.product_id
    WHERE DMI.stock_adjustment_id = p_stock_adjustment_id
    ORDER BY DMI.product_id
    FOR UPDATE OF PS;

    IF v_direction = 'OUT' THEN
        IF EXISTS (SELECT 1 FROM tmp_items WHERE qty > product_stock) THEN
            RAISE EXCEPTION 'La cantidad a retirar de uno o mas productos es mayor a la cantidad disponible en stock';
        END IF;
    END IF;

    UPDATE "stock_adjustment"
    SET
        status = 'confirmado',
        updated_at = NOW()
    WHERE id = p_stock_adjustment_id;

    INSERT INTO "kardex"(
        kardex_date, 
        product_id,
        type, 
        doc_id, 
        doc_type, 
        doc_serie,
        actual_qty, 
        after_qty,
        incoming_rate, 
        outgoing_rate,
        valuation_rate, 
        stock_value,
        updated_at
    )
    SELECT
        NOW(),
        TI.product_id,
        v_direction,
        p_stock_adjustment_id,
        'stock adjustment',
        v_serie,
        TI.product_stock,
        CASE WHEN v_direction = 'OUT' THEN TI.product_stock - TI.qty ELSE TI.product_stock + TI.qty END,
        CASE WHEN v_direction = 'IN'  THEN TI.valuation_rate ELSE 0 END,
        CASE WHEN v_direction = 'OUT' THEN TI.valuation_rate ELSE 0 END,
        valuation_rate,
        (CASE WHEN v_direction = 'OUT' THEN TI.product_stock - TI.qty ELSE TI.product_stock + TI.qty END) * TI.valuation_rate,
        NOW()
    FROM "tmp_items" TI;


    UPDATE "product_stock" AS PS
    SET
        stock = CASE WHEN v_direction = 'OUT' THEN PS.stock - TI.qty ELSE PS.stock + TI.qty END,
    stock_value = (CASE WHEN v_direction = 'OUT' THEN PS.stock - TI.qty ELSE PS.stock + TI.qty END) * PS.valuation_rate,
        updated_at = NOW()
    FROM tmp_items AS TI
    WHERE PS.product_id = TI.product_id;
END
$$;
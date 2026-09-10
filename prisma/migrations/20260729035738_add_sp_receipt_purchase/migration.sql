CREATE OR REPLACE PROCEDURE sp_CreateReceiptPurchase(
	p_purchase_id	INTEGER,
	p_userid		INTEGER,
	p_items         JSONB DEFAULT NULL
)
LANGUAGE plpgsql		
AS $$
DECLARE
	v_serie			TEXT;
	v_receipt_id	INTEGER;
	v_supplier_id	INTEGER;
	v_supplier_name	TEXT;
	v_supplier_ruc	TEXT;
	v_total			NUMERIC(12,2);
BEGIN 

	SELECT OP.supplier_id, OP.supplier_name, OP.supplier_ruc
	INTO v_supplier_id, v_supplier_name, v_supplier_ruc
	FROM "order_purchase" AS OP
	WHERE OP.id = p_purchase_id AND OP.status IN ('aprobado', 'parcial');
	
	IF NOT FOUND THEN
		RAISE EXCEPTION 'La orden de compra no existe o no está aprobada.';
	END IF;

	IF EXISTS (
		SELECT 1 FROM "receipt_purchase" WHERE purchase_id = p_purchase_id AND status = 'borrador'
	) THEN
		RAISE EXCEPTION 'Ya existe una orde de recepcion en proceso con esta orden de compra.';
	END IF;

	CREATE TEMP TABLE temp_receipt_items (
		detail_purchase_id	INTEGER,
		product_id	INTEGER, 
		product_name	TEXT,
		qty_pending	INTEGER,
		qty_received	INTEGER, 
		qty_reject	INTEGER,
		qty_accepted	INTEGER, 
		price	NUMERIC(12,2),
		subtotal	NUMERIC(12,2)
	) ON COMMIT DROP;

	INSERT INTO temp_receipt_items (
		detail_purchase_id,
		product_id, 
		product_name,
		qty_pending,
		qty_received, 
		qty_reject,
		qty_accepted, 
		price,
		subtotal
	)
	SELECT
		DOP.id,
		DOP.product_id,
		DOP.product_name,
		(DOP.qty - DOP.qty_received) as qty_pending,
		i.qty_received,
		i.qty_reject,
		(i.qty_received - i.qty_reject) AS qty_accepted,
		DOP.price,
		(DOP.price * (i.qty_received - i.qty_reject)) AS subtotal
	FROM jsonb_to_recordset(p_items) AS i(product_id INTEGER, qty_received INTEGER, qty_reject INTEGER)
	LEFT JOIN "detail_order_purchase" AS DOP ON DOP.purchase_id = p_purchase_id AND DOP.product_id = i.product_id;
	
	IF EXISTS (
		SELECT 1 FROM "temp_receipt_items" AS TRI WHERE TRI.detail_purchase_id IS NULL
	) THEN
		RAISE EXCEPTION 'El producto elegido no existe en la orden de compra.';
	END IF;

	IF EXISTS (
		SELECT 1 FROM "temp_receipt_items" AS TRI WHERE TRI.qty_accepted > TRI.qty_pending
	) THEN
		RAISE EXCEPTION 'El cantidad aceptada es mayor a la cantidad faltante.';
	END IF;
	
	v_serie := 'RECEP-' || LPAD(nextval('receipt_purchase_serie')::TEXT, 6, '0');
	
	SELECT SUM(subtotal) INTO v_total FROM "temp_receipt_items";
	
	INSERT INTO "receipt_purchase"(serie, purchase_id, status, supplier_id, supplier_name, supplier_ruc, date_receipt, note, total, user_id, updated_at) 
	VALUES(v_serie, p_purchase_id, 'borrador', v_supplier_id, v_supplier_name, v_supplier_ruc, NOW(), NULL, v_total, p_userid,NOW())
	RETURNING id INTO v_receipt_id;

	INSERT INTO "detail_receipt_purchase"(receipt_id, detail_purchase_id, product_id, product_name, qty_received, qty_reject, qty_accepted, price, subtotal, updated_at)
	SELECT
		v_receipt_id,
		TRI.detail_purchase_id,
		TRI.product_id,
		TRI.product_name,
		TRI.qty_received,
		TRI.qty_reject,
		TRI.qty_accepted,
		TRI.price,
		TRI.subtotal,
		NOW()
	FROM "temp_receipt_items" AS TRI;
END
$$;


CREATE OR REPLACE PROCEDURE sp_UpdateReceiptPurchase(
	p_receipt_id	INTEGER,
	p_items         JSONB 
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_purchase_id	INTEGER;
	v_total 		NUMERIC(12,2);
BEGIN
	SELECT RP.purchase_id
	INTO v_purchase_id
	FROM "receipt_purchase" AS RP
	WHERE RP.id = p_receipt_id AND RP.status = 'borrador';

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La recepcion no existe o no está en borrador.';
	END IF;

	CREATE TEMP TABLE temp_receipt_items (
		detail_purchase_id	INTEGER,
		product_id	INTEGER, 
		product_name	TEXT,
		qty_pending	INTEGER,
		qty_received	INTEGER, 
		qty_reject	INTEGER,
		qty_accepted	INTEGER, 
		price	NUMERIC(12,2),
		subtotal	NUMERIC(12,2)
	) ON COMMIT DROP;

	INSERT INTO temp_receipt_items (
		detail_purchase_id,
		product_id, 
		product_name,
		qty_pending,
		qty_received, 
		qty_reject,
		qty_accepted, 
		price,
		subtotal
	)
	SELECT
		DOP.id,
		DOP.product_id,
		DOP.product_name,
		(DOP.qty - DOP.qty_received) as qty_pending,
		i.qty_received,
		i.qty_reject,
		(i.qty_received - i.qty_reject) AS qty_accepted,
		DOP.price,
		(DOP.price * (i.qty_received - i.qty_reject)) AS subtotal
	FROM jsonb_to_recordset(p_items) AS i(product_id INTEGER, qty_received INTEGER, qty_reject INTEGER)
	LEFT JOIN "detail_order_purchase" AS DOP ON DOP.purchase_id = v_purchase_id AND DOP.product_id = i.product_id;

	IF EXISTS (
		SELECT 1 FROM "temp_receipt_items" AS TRI WHERE TRI.detail_purchase_id IS NULL
	) THEN
		RAISE EXCEPTION 'El producto elegido no existe en la orden de compra.';
	END IF;

	IF EXISTS (
		SELECT 1 FROM "temp_receipt_items" AS TRI WHERE TRI.qty_accepted > TRI.qty_pending
	) THEN
		RAISE EXCEPTION 'El cantidad aceptada es mayor a la cantidad faltante.';
	END IF;

	SELECT SUM(subtotal) INTO v_total FROM "temp_receipt_items";

	INSERT INTO "detail_receipt_purchase" (
		receipt_id, 
		detail_purchase_id, 
		product_id, 
		product_name, 
		qty_received, 
		qty_reject, 
		qty_accepted, 
		price, 
		subtotal, 
		updated_at
	)
	SELECT
		p_receipt_id,
		TRI.detail_purchase_id,
		TRI.product_id,
		TRI.product_name,
		TRI.qty_received,
		TRI.qty_reject,
		TRI.qty_accepted,
		TRI.price,
		TRI.subtotal,
		NOW()
	FROM "temp_receipt_items" AS TRI
	WHERE NOT EXISTS (
		SELECT 1 FROM "detail_receipt_purchase" AS DRP 
		WHERE 
			DRP.receipt_id = p_receipt_id AND 
			DRP.product_id = TRI.product_id
	);

	UPDATE "detail_receipt_purchase" AS DRP
	SET
		qty_received = TRI.qty_received, 
		qty_reject = TRI.qty_reject,
		qty_accepted = TRI.qty_accepted,
		subtotal = TRI.subtotal, 
		updated_at = NOW()
	FROM temp_receipt_items AS TRI
	WHERE 
		DRP.receipt_id = p_receipt_id AND 
		DRP.product_id = TRI.product_id 
	AND(
		DRP.qty_received IS DISTINCT FROM TRI.qty_received OR
		DRP.qty_reject IS DISTINCT FROM TRI.qty_reject
	);

	DELETE FROM "detail_receipt_purchase" AS DRP
	WHERE 
		DRP.receipt_id = p_receipt_id 
		AND NOT EXISTS (
			SELECT 1 FROM temp_receipt_items AS TRI WHERE TRI.product_id = DRP.product_id 
		);	
END
$$;


CREATE OR REPLACE PROCEDURE sp_ConfirmReceiptPurchase(
	p_receipt_id	INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_total_purchase	INTEGER;
	v_total_received	INTEGER;
	v_purchase_id		INTEGER;
	v_receipt_serie 	TEXT;
	v_date_receipt		DATE;
BEGIN
	SELECT 
		RP.purchase_id,
		RP.serie,
		RP.date_receipt
	INTO
		v_purchase_id,
		v_receipt_serie,
		v_date_receipt
	FROM "receipt_purchase" AS RP 
	WHERE RP.id = p_receipt_id AND RP.status = 'borrador'
	FOR UPDATE;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La recepcion de compra no existe o no está aprobada.';
	END IF;

	PERFORM 1
	FROM "order_purchase" AS OP
	WHERE OP.id = v_purchase_id AND OP.status = 'aprobado'
	FOR UPDATE;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La orden de compra no existe o no está aprobada.';
	END IF;

	CREATE TEMP TABLE tmp_receipt_items (
		-- info product
		product_id      		INTEGER,
		product_name			TEXT,
		detail_purchase_id    	INTEGER,

		-- cantidades a mover
		actual_qty				INTEGER,
		incoming_rate			NUMERIC(12,2),

		-- stock antes del movimiento
		stock_before			INTEGER,
		stock_value_before		NUMERIC(12,2),
		valuation_rate_before	NUMERIC(12,2),

		-- stock despues del movimiento
		stock_after				INTEGER,
		stock_value_after		NUMERIC(12,2),
		valuation_rate_after	NUMERIC(12,2),

		-- stock del kardex
		stock_value_kardex		NUMERIC(12,2)
	) ON COMMIT DROP;

	INSERT INTO "tmp_receipt_items"(
		-- info product
		product_id,
		product_name,
		detail_purchase_id,

		-- cantidades a mover
		actual_qty,
		incoming_rate,

		-- stock antes del movimiento
		stock_before,
		stock_value_before,
		valuation_rate_before,

		-- stock despues del movimiento
		stock_after,
		stock_value_after,
		valuation_rate_after,

		-- stock del kardex
		stock_value_kardex
	)
	SELECT 
		-- info product
		DRP.product_id,
		DRP.product_name,
		DRP.detail_purchase_id,
		-- cantidades a mover
		DRP.qty_accepted AS actual_qty,
		DRP.price AS incoming_rate,
		-- stock antes del movimiento
		PS.stock AS stock_before,
		PS.stock_value AS stock_value_before,
		PS.valuation_rate AS valuation_rate_before,
		-- stock despues del movimiento
		(PS.stock + DRP.qty_accepted) AS stock_after,
		(PS.stock_value + DRP.subtotal) AS stock_value_after,
		((PS.stock_value + DRP.subtotal)/(PS.stock + DRP.qty_accepted)) AS valuation_rate_after,
		-- stock del kardex
		(PS.stock_value + DRP.subtotal) AS stock_value_kardex
	FROM "detail_receipt_purchase" AS DRP
	INNER JOIN "product_stock" AS PS ON DRP.product_id = PS.product_id
	WHERE 
		DRP.receipt_id = p_receipt_id AND
		DRP.qty_accepted > 0
	FOR UPDATE OF PS, DRP;

	-- modificar lo recibido en la orden de compra
	UPDATE "detail_order_purchase" AS DOP
    SET qty_received = DOP.qty_received + TRI.actual_qty,
        updated_at   = NOW()
    FROM "tmp_receipt_items" AS TRI
    WHERE DOP.id = TRI.detail_purchase_id;
		
	-- modificar el stock de cada producto
	UPDATE product_stock AS PS
    SET stock          = TRI.stock_after,
        valuation_rate = TRI.valuation_rate_after,
        stock_value    = TRI.stock_value_after,
        updated_at     = NOW()
    FROM "tmp_receipt_items" AS TRI
	WHERE PS.product_id  = TRI.product_id;

	-- insertar en el kardex
	INSERT INTO kardex(
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
		v_date_receipt,
		TRI.product_id,
        'IN',
        p_receipt_id,
        'receipt purchase',
        v_receipt_serie,
        TRI.actual_qty,
        TRI.stock_after,
        TRI.incoming_rate,
        0,
        TRI.valuation_rate_after,
        TRI.stock_value_after,
        NOW()
	FROM "tmp_receipt_items" AS TRI;
	
	-- modificar el estado de la orden
	SELECT
        SUM(qty),
        SUM(qty_received)
    INTO
        v_total_purchase,
        v_total_received
    FROM detail_order_purchase
    WHERE purchase_id  = v_purchase_id;

	-- modificar el estado de la orden de compra
	UPDATE "order_purchase" AS OP
	SET
		status = CASE 
					 WHEN v_total_received = 0 THEN 'aprobado'
					 WHEN v_total_received >= v_total_purchase THEN 'recibido'
					 ELSE 'parcial' 
				 END,
		updated_at = NOW()
	WHERE OP.id = v_purchase_id;

	-- modificar el estado de la recepcion de compra
	UPDATE "receipt_purchase"
	SET
		status = 'confirmado'
	WHERE
		id = p_receipt_id AND
		status = 'borrador';
END
$$;
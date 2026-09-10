-- This is an empty migration.
CREATE OR REPLACE PROCEDURE sp_CreateOrderPurchase(
	p_userid		INTEGER,
	p_supplierid	INTEGER,
	p_address		TEXT,
	p_delivery_date	DATE,
	p_items         JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
	p_serie		TEXT;
	p_supplier_name	TEXT;
	p_supplier_ruc	TEXT;
	p_purchase_id	INTEGER;
	p_total			NUMERIC(12,2);
BEGIN
	SELECT 
		S.name, 
		S.ruc
    INTO 
		p_supplier_name, 
		p_supplier_ruc
	FROM "supplier" AS S
	WHERE S.id = p_supplierid;
	
	IF p_supplier_name IS NULL OR p_supplier_ruc IS NULL THEN
		RAISE EXCEPTION 'El proveedor elegido no existe.';
	END IF;
	
	CREATE TEMP TABLE tmp_order_items (
        product_id      INTEGER,
        product_name    TEXT,
        qty             INTEGER,
        price           NUMERIC(12,2),
        subtotal        NUMERIC(12,2)
    ) ON COMMIT DROP;
	
	INSERT INTO tmp_order_items (
		product_id, 
		product_name, 
		qty, 
		price, 
		subtotal
	)
	SELECT
		P.id,
		P.name,
		i.qty,
		i.price,
		i.price * i.qty AS subtotal
	FROM jsonb_to_recordset(p_items) AS i(product_id INTEGER, qty INTEGER, price NUMERIC, subtotal NUMERIC)
	LEFT JOIN "product" AS P ON p.id = i.product_id;
	
	IF EXISTS (
		SELECT TOI.product_id FROM tmp_order_items AS TOI WHERE TOI.product_id IS NULL
	) THEN
		RAISE EXCEPTION 'El producto elegido no existe.';
	END IF;
	
	p_serie := 'ORD-' || LPAD(nextval('order_purchase_serie')::TEXT, 6, '0');
	
	SELECT SUM(qty * price) INTO p_total FROM tmp_order_items;
	
	INSERT INTO "order_purchase" (serie, supplier_id, supplier_name, supplier_ruc, status, address_purchase, delivery_date, total, user_id, updated_at) 
	VALUES(p_serie, p_supplierid, p_supplier_name, p_supplier_ruc, 'borrador', p_address, p_delivery_date, p_total, p_userid, NOW())
	RETURNING id INTO p_purchase_id;

	INSERT INTO "detail_order_purchase" (
		purchase_id, 
		product_id, 
		product_name,
		qty_received,
		qty, 
		price, 
		subtotal, 
		updated_at
	)
	SELECT
		p_purchase_id,
		TOI.product_id,
		TOI.product_name,
		0,
		TOI.qty,
		TOI.price,
		TOI.subtotal,
		NOW()
	FROM tmp_order_items AS TOI;
END
$$;

CREATE OR REPLACE PROCEDURE sp_UpdateOrderPurchase(
	p_purchase_id	INTEGER,	
	p_supplierid	INTEGER DEFAULT NULL,
	p_address		TEXT DEFAULT NULL,
	p_delivery_date	DATE DEFAULT NULL,
	p_items         JSONB DEFAULT NULL
)
LANGUAGE plpgsql		
AS $$
DECLARE
	p_supplier_name	TEXT;
	p_supplier_ruc	TEXT;
	p_total			NUMERIC(12,2);
BEGIN 
	IF NOT EXISTS (
		SELECT 
			1 
		FROM "order_purchase" AS O 
		WHERE 
			O.id = p_purchase_id AND
			O.status = 'borrador'
	) THEN
		 RAISE EXCEPTION 'La orden de compra no existe o está confirmada.';
	END IF;

	IF p_supplierid IS NOT NULL THEN 
		SELECT 
			S.name, 
			S.ruc
	    INTO 
			p_supplier_name, 
			p_supplier_ruc
		FROM "supplier" AS S
		WHERE S.id = p_supplierid;

		IF p_supplier_name IS NULL OR p_supplier_ruc IS NULL THEN
			RAISE EXCEPTION 'El proveedor elegido no existe.';
		END IF;
	END IF;

	IF p_items IS NOT NULL THEN
		CREATE TEMP TABLE tmp_order_items (
	        product_id      INTEGER,
	        product_name    TEXT,
	        qty             INTEGER,
	        price           NUMERIC(12,2),
	        subtotal        NUMERIC(12,2)
	    ) ON COMMIT DROP;
	
		INSERT INTO tmp_order_items (
			product_id, 
			product_name, 
			qty, 
			price, 
			subtotal
		)
		SELECT
			P.id,
			P.name,
			i.qty,
			i.price,
			i.price * i.qty AS subtotal
		FROM jsonb_to_recordset(p_items) AS i(product_id INTEGER, qty INTEGER, price NUMERIC, subtotal NUMERIC)
		LEFT JOIN "product" AS P ON p.id = i.product_id;
	
		IF EXISTS (
			SELECT TOI.product_id FROM tmp_order_items AS TOI WHERE TOI.product_id IS NULL
		) THEN
			RAISE EXCEPTION 'El producto elegido no existe.';
		END IF;
	
		SELECT SUM(qty * price) INTO p_total FROM tmp_order_items;

		INSERT INTO "detail_order_purchase" (
			purchase_id, 
			product_id, 
			product_name, 
			qty_received,
			qty, 
			price, 
			subtotal, 
			updated_at
		)
		SELECT
			p_purchase_id,
			TOI.product_id,
			TOI.product_name,
			0,
			TOI.qty,
			TOI.price,
			TOI.subtotal,
			NOW()
		FROM tmp_order_items AS TOI
		WHERE NOT EXISTS (
			SELECT 1 FROM "detail_order_purchase" AS DOP 
			WHERE 
				DOP.purchase_id = p_purchase_id AND 
				DOP.product_id = TOI.product_id
		);

		UPDATE "detail_order_purchase" AS DOP
		SET
			qty = TOI.qty, 
			price = TOI.price, 
			subtotal = TOI.subtotal, 
			updated_at = NOW()
		FROM tmp_order_items AS TOI
		WHERE 
			DOP.purchase_id = p_purchase_id AND 
			DOP.product_id = TOI.product_id 
		AND(
			DOP.qty		IS DISTINCT FROM TOI.qty OR
			DOP.price	IS DISTINCT FROM TOI.price
		);

		DELETE FROM "detail_order_purchase" AS DOP
		WHERE 
			DOP.purchase_id = p_purchase_id 
			AND NOT EXISTS (
				SELECT 1 FROM tmp_order_items AS TOI WHERE TOI.product_id = DOP.product_id 
			);
		
	END IF;
	
	UPDATE "order_purchase" AS O
	SET
		supplier_id = COALESCE(p_supplierid, supplier_id),
		supplier_name = COALESCE(p_supplier_name, supplier_name),
		supplier_ruc = COALESCE(p_supplier_ruc,  supplier_ruc),
		address_purchase = COALESCE(p_address, address_purchase),
		delivery_date = COALESCE(p_delivery_date, delivery_date),
		total = CASE WHEN p_items IS NOT NULL THEN p_total ELSE total END,
		updated_at = NOW()
	WHERE O.id = p_purchase_id;
END
$$
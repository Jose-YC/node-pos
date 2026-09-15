CREATE OR REPLACE PROCEDURE sp_CreateSale(
    p_user_id                   INTEGER,
    p_document_type_sale_id     VARCHAR(2),
    p_box_open_id               INTEGER,
    p_paid_amount               NUMERIC(12,2),
    p_items                     JSONB,
    p_payment                   JSONB,
    p_customer_id               INTEGER DEFAULT NULL,         
    p_customer_name             VARCHAR(200) DEFAULT NULL,         
    p_customer_type_code        VARCHAR(2) DEFAULT NULL,      
    p_customer_type_number      VARCHAR(15) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_serie				        TEXT;
	v_sale_id			        INTEGER;

    v_customer_name             VARCHAR(200);
    v_customer_type_code        VARCHAR(2);
    v_customer_type_number      VARCHAR(15);

    v_taxable_amount            NUMERIC(12,2);
    v_igv_total                 NUMERIC(12,2);
    v_total                     NUMERIC(12,2);
    v_change_amount             NUMERIC(12,2);
BEGIN

	-- validacion si se tiene una caja de venta abierta
	IF NOT EXISTS (
		SELECT 1 
		FROM "box_open" as BO 
		WHERE 
			BO.id = p_box_open_id AND 
			BO.user_id = p_user_id AND 
			BO.status = 'abierto'
	) THEN
        RAISE EXCEPTION 'No tiene una caja de venta abierta';
	END IF;

	-- validacion de el tipo de documento de venta
    IF NOT EXISTS (
		SELECT 1
        FROM   type_document_sale AS T
        WHERE  T.id = p_document_type_sale_id AND T.status = true
	) THEN
        RAISE EXCEPTION 'El tipo de documento de venta no existe o esta desactivado';
	END IF;

	-- validacion de metodos de pago 
	IF EXISTS (
		SELECT 1
		FROM jsonb_to_recordset(p_payment) AS JP(payment_id INTEGER)
		LEFT JOIN "payment" P ON P.id = JP.payment_id AND P.status = true
		WHERE P.id IS NULL
	) THEN
		RAISE EXCEPTION 'Uno de los metodos de pago no existe o esta desactivado';
	END IF;

	-- rellenar tabla temmporal con productos
    CREATE TEMP TABLE tmp_sale_items (
        product_id      INTEGER,
        product_name    TEXT,
        product_stock   INTEGER,
        qty             INTEGER,
        price           NUMERIC(12,2),
        subtotal        NUMERIC(12,2),
        valuation_rate  NUMERIC(12,2)
    ) ON COMMIT DROP;

    INSERT INTO "tmp_sale_items" (product_id, product_name, product_stock, qty, price, subtotal, valuation_rate)
    SELECT
        P.id                            AS product_id,
        P.name                          AS product_name,
        PS.stock                        AS product_stock,
        I.qty,
        PP.amount                       AS price,
        (I.qty * PP.amount)             AS subtotal,
        PS.valuation_rate               AS valuation_rate
    FROM jsonb_to_recordset(p_items) AS I(product_id INTEGER, qty INTEGER)
    LEFT JOIN "product" AS P ON P.id = I.product_id AND P.status = true
    JOIN "product_price" AS PP ON P.id = PP.product_id AND PP.selling = true
    JOIN "product_stock" AS PS ON P.id = PS.product_id
    FOR UPDATE OF PS;

    -- validacion de existencia de los productos
    IF EXISTS (SELECT 1 FROM "tmp_sale_items" WHERE product_id IS NULL) THEN
        RAISE EXCEPTION 'Un producto o mas no existen';
    END IF;

    -- validacion de cantidad de stock
    IF EXISTS (SELECT 1 FROM "tmp_sale_items" WHERE qty > product_stock) THEN
        RAISE EXCEPTION 'Stock insuficiente para uno o más productos';
    END IF;

    -- validacion de totales
    SELECT
        COALESCE(SUM(subtotal), 0)
    INTO 
        v_taxable_amount
    FROM "tmp_sale_items";

    v_igv_total     := ROUND(v_taxable_amount * 0.18, 2);
    v_total         := ROUND(v_taxable_amount + v_igv_total, 2);
    v_change_amount := ROUND(p_paid_amount - v_total, 2);

    IF p_paid_amount < v_total THEN
        RAISE EXCEPTION 'El monto pagado (%.2f) es menor al total de la venta (%.2f)', p_paid_amount, v_total;
    END IF;

    -- validacion del cliente
    IF p_customer_id IS NULL AND p_customer_name IS NULL AND p_customer_type_code IS NULL AND p_customer_type_number IS NULL THEN
        IF v_total >= 700 AND p_document_type_sale_id = '03' THEN
            RAISE EXCEPTION 'No puedes usar un cliente general con un monto igual o superior a 700';
        END IF;
        
        SELECT 
			name, 
			doc_type_code, 
			doc_type_number
        INTO 
			v_customer_name, 
			v_customer_type_code, 
			v_customer_type_number
        FROM "customer"
        WHERE is_generic = true
          AND deleted_at IS NULL;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'El cliente generico no esta activado';
        END IF;

        IF p_customer_type_code = '06' THEN
            RAISE EXCEPTION 'No puedes usar un cliente generico en este tipo de documento de venta';
        END IF;
    END IF;

    IF p_customer_name IS NOT NULL AND p_customer_type_code IS NOT NULL AND p_customer_type_number IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM "identity_document_type" AS IDT WHERE IDT.id = p_customer_type_code
        ) THEN
            RAISE EXCEPTION 'Este tipo de documento de identidad no esta disponible';
        END IF;

        v_customer_name := p_customer_name;
        v_customer_type_code := p_customer_type_code;
        v_customer_type_number := p_customer_type_number;
    END IF;

    IF p_customer_id IS NOT NULL THEN
        SELECT 
			name, 
			doc_type_code, 
			doc_type_number
        INTO 
			v_customer_name, 
			v_customer_type_code, 
			v_customer_type_number
        FROM "customer"
        WHERE id = p_customer_id
          AND deleted_at IS NULL;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'El cliente seleccionado no existe';
        END IF;

        -- validacion de documento de identidad y documento de venta
        IF p_customer_type_code <> '06' AND p_document_type_sale_id = '01' THEN
            RAISE EXCEPTION 'El tipo de documento del cliente no es apto para esta documento de venta';
        END IF;

        IF p_document_type_sale_id = '03' AND p_customer_type_code = '06' THEN
            RAISE EXCEPTION 'El tipo de documento del cliente no es apto para esta documento de venta';
        END IF;
    END IF;

    -- generar serie
    IF p_document_type_sale_id = '01' THEN 
		v_serie := 'F001-' || LPAD(nextval('sale_factura_serie')::TEXT, 6, '0');
	ELSE
    	v_serie := 'B001-' || LPAD(nextval('sale_boleta_serie')::TEXT, 6, '0');
	END IF;

    -- insertar sale
    INSERT INTO "sale" (
        serie, 
        box_open_id,
        type_code, 
        user_id, 
        sale_date, 
        customer_id,
        customer_name, 
        customer_doc_code, 
        customer_doc_number, 
        igv_rate, 
        taxable_amount, 
        igv_total, 
        total, 
        paid_amount, 
        change_amount, 
        is_return, 
        return_against_id, 
        updated_at
    )
    VALUES(
        v_serie, 
        p_box_open_id,
        p_document_type_sale_id, 
        p_user_id,
        NOW(),
        p_customer_id, 
        v_customer_name, 
        v_customer_type_code, 
        v_customer_type_number,
        0.18, 
        v_taxable_amount, 
        v_igv_total, 
        v_total, 
        p_paid_amount, 
        v_change_amount, 
        false, 
        NULL, 
        NOW()
    ) RETURNING id INTO v_sale_id;

	-- insertar detalle sale
    INSERT INTO detail_sale (sale_id, product_id, product_name, qty, valuation_rate, price, subtotal, updated_at)
    SELECT
        v_sale_id,
        product_id,
        product_name,
        qty,
        valuation_rate,
        price,
        subtotal,
        NOW()
    FROM "tmp_sale_items";

    -- insertar  metodos de pago
	INSERT INTO "sale_payment" (sale_id, box_open_id, payment_id, payment_name, amount, updated_at)
	SELECT
		v_sale_id,
        p_box_open_id,
		P.id,
		P.name,
		JP.amount,
		NOW()
	FROM jsonb_to_recordset(p_payment) AS JP(payment_id INTEGER, amount NUMERIC(12,2))
	JOIN "payment" AS P ON P.id = JP.payment_id;

    -- insertar kardex
    INSERT INTO kardex (
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
        TSI.product_id,
        'OUT',
        v_sale_id,
        'sale',
        v_serie,
        TSI.product_stock,
        TSI.product_stock - TSI.qty,
        0,                          
        TSI.price,               
        TSI.valuation_rate,
        (TSI.product_stock - TSI.qty) * TSI.valuation_rate,
        NOW()
    FROM "tmp_sale_items" TSI; 

    -- actualizar stock
    UPDATE "product_stock" AS PS
    SET
        stock       = PS.stock - TSI.qty,
        stock_value = (PS.stock - TSI.qty) * PS.valuation_rate,
        updated_at  = NOW()
    FROM "tmp_sale_items" TSI
    WHERE PS.product_id = TSI.product_id;
END
$$;

CREATE OR REPLACE PROCEDURE sp_CreateCreditNote(
    p_user_id                   INTEGER,
    p_sale_id                   INTEGER,
    p_paid_amount               NUMERIC(12,2),
    p_box_open_id               INTEGER,
    p_items                     JSONB,
    p_payment                   JSONB,
    p_notes                     VARCHAR(200) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_serie				            TEXT;
	v_sale_return_id		        INTEGER;

    v_taxable_amount            NUMERIC(12,2);
    v_igv_total                 NUMERIC(12,2);
    v_total                     NUMERIC(12,2);
BEGIN
    -- validacion de venta original
    IF NOT EXISTS (
        SELECT 1
        FROM "sale" AS S
        WHERE 
            id = p_sale_id AND 
            is_return = false
    ) THEN
        RAISE EXCEPTION 'La venta seleccionada no existe o es una devolución';
    END IF;

    -- validacion si se tiene una caja de venta abierta
	IF NOT EXISTS (
		SELECT 1 
		FROM "box_open" as BO 
		WHERE 
			BO.id = p_box_open_id AND 
			BO.user_id = p_user_id AND 
			BO.status = 'abierto'
	) THEN
        RAISE EXCEPTION 'No tiene una caja de venta abierta';
	END IF;

    -- validacion de tipo de documento de venta
    IF NOT EXISTS (
        SELECT 1
        FROM "type_document_sale" AS TDS
        WHERE 
            TDS.id = '07' AND 
            TDS.status = true
    ) THEN
        RAISE EXCEPTION 'El tipo de documento de venta no existe o esta desactivado';
    END IF;

    -- validacion de metodos de pago 
	IF EXISTS (
		SELECT 1
		FROM jsonb_to_recordset(p_payment) AS JP(payment_id INTEGER)
		LEFT JOIN "payment" P ON P.id = JP.payment_id AND P.status = true
		WHERE P.id IS NULL
	) THEN
		RAISE EXCEPTION 'Uno de los metodos de pago no existe o esta desactivado';
	END IF;

    -- crear tabla temmporal con productos
    CREATE TEMP TABLE tmp_sale_return_items (
        product_id      INTEGER,
        product_name    TEXT,
        sale_qty        INTEGER,
        returned_qty    INTEGER,
        qty             INTEGER,
        price           NUMERIC(12,2),
        subtotal        NUMERIC(12,2),
        valuation_rate  NUMERIC(12,2)
    ) ON COMMIT DROP;

    -- rellenar tabla temmporal con productos
    INSERT INTO "tmp_sale_return_items" (product_id, product_name, sale_qty, returned_qty, qty, price, subtotal, valuation_rate)
    WITH 
        items_product AS (
            SELECT 
                product_id, 
                qty
            FROM jsonb_to_recordset(p_items) AS x(product_id INT, qty INT)
        ),
        products_sale AS (
            SELECT
                DS.product_id,
                DS.qty AS sale_qty,
                DS.product_name,
                DS.price,
                DS.valuation_rate
            FROM "items_product" AS IP
            INNER JOIN "detail_sale" AS DS ON IP.product_id = DS.product_id
            WHERE DS.sale_id = p_sale_id
        ),
        products_returned AS (
            SELECT 
                DS.product_id,
                COALESCE(SUM(ABS(DS.qty)), 0) AS returned_qty
            FROM "items_product" AS IP 
            INNER JOIN "detail_sale" AS DS ON DS.product_id = IP.product_id
            INNER JOIN "sale" S ON S.id = DS.sale_id
            WHERE S.return_against_id = p_sale_id AND S.is_return = TRUE
            GROUP BY DS.product_id
        )
    SELECT 
        PS.product_id,
        PS.product_name,
        PS.sale_qty,
        COALESCE(PR.returned_qty, 0) AS returned_qty,
        IP.qty,
        PS.price,
        ROUND(IP.qty * PS.price, 2) AS subtotal,
        PS.valuation_rate
    FROM items_product AS IP
    LEFT JOIN products_sale AS PS ON PS.product_id = IP.product_id
    LEFT JOIN products_returned AS PR ON PR.product_id = PS.product_id;

    -- validacion de existencia de los productos
    IF EXISTS (
        SELECT 1 FROM "tmp_sale_return_items" AS TSRI
        WHERE TSRI.product_id IS NULL 
    ) THEN
        RAISE EXCEPTION 'Hay productos que no pertenecen a la venta original';
    END IF;

    -- validacion de cantidad a devolver
    IF EXISTS (
        SELECT 1 FROM "tmp_sale_return_items" AS TSRI
        WHERE TSRI.qty > (TSRI.sale_qty - TSRI.returned_qty)
    ) THEN
        RAISE EXCEPTION 'Hay productos que exceden la cantidad de la venta original';
    END IF;

    -- validacion de totales
    SELECT
        COALESCE(SUM(subtotal), 0)
    INTO 
        v_taxable_amount
    FROM "tmp_sale_return_items";

    v_igv_total     := ROUND(v_taxable_amount * 0.18, 2);
    v_total         := ROUND(v_taxable_amount + v_igv_total, 2);

    IF p_paid_amount > v_total THEN
        RAISE EXCEPTION 'El monto de pagos supera el total a devolver';
    END IF;

    -- generar serie
	v_serie := 'N001-' || LPAD(nextval('nota_credito_serie')::TEXT, 6, '0');

    -- insertar sale return
    INSERT INTO "sale" (
        serie, 
        box_open_id,
        type_code, 
        user_id, 
        sale_date, 
        customer_id,
        customer_name, 
        customer_doc_code, 
        customer_doc_number, 
        igv_rate, 
        taxable_amount, 
        igv_total, 
        total, 
        paid_amount, 
        change_amount, 
        is_return, 
        return_against_id,
        notes,
        updated_at
    )
    SELECT
        v_serie,
        p_box_open_id,
        '07',
        p_user_id,
        NOW(),
        S.customer_id,
        S.customer_name,
        S.customer_doc_code,
        S.customer_doc_number,
        0.18,
        v_taxable_amount,
        v_igv_total,
        v_total,
        v_total_payment,
        0,
        true,
        S.id,
        p_notes,
        NOW()
    FROM "sale" AS S
    WHERE S.id = p_sale_id
    RETURNING id INTO v_sale_return_id;

    -- insertar detalle sale return
    INSERT INTO detail_sale (sale_id, product_id, product_name, qty, price, subtotal, valuation_rate, updated_at)
    SELECT
        v_sale_return_id,
        product_id,
        product_name,
        qty,
        price,
        subtotal,
        valuation_rate,
        NOW()
    FROM "tmp_sale_return_items";

    -- insertar metodos de pago
	INSERT INTO "sale_payment" (sale_id, box_open_id, payment_id, payment_name, amount, updated_at)
	SELECT
		v_sale_return_id,
        p_box_open_id,
		P.id,
		P.name,
		JP.amount,
		NOW()
	FROM jsonb_to_recordset(p_payment) AS JP(payment_id INTEGER, amount NUMERIC(12,2))
	JOIN "payment" AS P ON P.id = JP.payment_id;

    -- bloquear stock de los productos a devolver
    PERFORM 1
    FROM product_stock AS PS
    INNER JOIN tmp_sale_return_items AS TSRI ON TSRI.product_id = PS.product_id
    ORDER BY PS.product_id
    FOR UPDATE OF PS;

    -- Actualizar stock
    UPDATE product_stock AS PS
    SET
        stock       = PS.stock + TSRI.qty,
        stock_value = (PS.stock + TSRI.qty) * PS.valuation_rate,
        updated_at  = NOW()
    FROM tmp_sale_return_items AS TSRI
    WHERE PS.product_id = TSRI.product_id
      AND PS.deleted_at IS NULL;

    -- insertat Kárdex
    INSERT INTO kardex (
        kardex_date, product_id, type, doc_id, doc_type, doc_serie,
        actual_qty, after_qty, incoming_rate, outgoing_rate,
        valuation_rate, stock_value, created_at, updated_at
    )
    SELECT
        CURRENT_DATE,
        TSRI.product_id,
        'IN',
        v_sale_return_id,
        'nota credito',
        v_serie,
        PS.stock - TSRI.qty,
        PS.stock,
        TSRI.valuation_rate,
        0,
        TSRI.valuation_rate,
        PS.stock_value,
        NOW(),
        NOW()
    FROM tmp_sale_return_items AS TSRI
    JOIN product_stock AS PS ON PS.product_id = TSRI.product_id;
END
$$;
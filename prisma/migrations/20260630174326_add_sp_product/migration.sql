CREATE OR REPLACE PROCEDURE sp_CreateProduct(
	p_name	TEXT,
	p_description	TEXT,
	p_image	TEXT,
	p_category_id	INTEGER,
	p_min_order_qty	INTEGER,
	p_min_stock	INTEGER,	
	p_status	BOOLEAN,
	p_price_buying	NUMERIC(8,2),
	p_price_selling	NUMERIC(8,2)
)
LANGUAGE plpgsql
AS $$
DECLARE
	p_product_id	INTEGER;	
	p_category_name	TEXT;
	p_sku			TEXT;
BEGIN
	IF EXISTS (
		SELECT 1 FROM "product" AS P WHERE P.sku = p_sku
	) THEN
		RAISE EXCEPTION 'El sku del producto ya existe y no puedes duplicarlo.';	
	END IF;

	SELECT 
		C.name INTO p_category_name 
	FROM "category" AS C
	WHERE C.id = p_category_id;

	IF p_category_name IS NULL THEN
		RAISE EXCEPTION 'La categoria del producto no existe.';
	END IF;
	
	p_sku := UPPER(SUBSTRING(p_category_name FROM 1 FOR 3)) || '-' || LPAD(nextval('product_sku')::TEXT, 6, '0');
	
	INSERT INTO "product" (
		sku, 
		name, 
		description, 
		image, 
		min_order_qty, 
		min_stock, 
		status, 
		category_id, 
		updated_at
	) 
	VALUES (
		p_sku, 
		p_name, 
		p_description, 
		p_image, 
		p_min_order_qty, 
		p_min_stock,
		p_status, 
		p_category_id, 
		NOW()
	) RETURNING id INTO p_product_id;

	INSERT INTO "product_price" (
		product_id, 
		product_name, 
		product_description, 
		buying, 
		selling, 
		amount, 
		updated_at
	)
	VALUES (
		p_product_id, 
		p_name, 
		p_description, 
		true, 
		false, 
		p_price_buying, 
		NOW()
	);

	INSERT INTO "product_price" (product_id, product_name, product_description, buying, selling, amount, updated_at)
	VALUES (p_product_id, p_name, p_description, false, true, p_price_selling, NOW());

	INSERT INTO "product_stock" (product_id, stock, valuation_rate, stock_value, updated_at)
	VALUES (p_product_id,0,0,0, NOW());
END
$$;

CREATE OR REPLACE PROCEDURE sp_UpdateProduct(
    p_product_id    INTEGER,
	p_name	TEXT DEFAULT NULL,
	p_description	TEXT DEFAULT NULL,
	p_category_id	INTEGER DEFAULT NULL,
	p_min_order_qty	INTEGER DEFAULT NULL,
	p_min_stock	INTEGER DEFAULT NULL		
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
		SELECT 1 FROM "product" AS P WHERE P.id = p_product_id
	) THEN
		RAISE EXCEPTION 'El producto a modificar no existe.';	
	END IF;
	
	IF p_category_id IS NOT NULL THEN
	    IF NOT EXISTS (
	        SELECT 1
	        FROM category
	        WHERE id = p_category_id
	    ) THEN
	        RAISE EXCEPTION 'La categoria del producto no existe.';
	    END IF;
	END IF;

	UPDATE "product" AS P
	SET 
		name = COALESCE(p_name, name),
		description = COALESCE(p_description, description),
		category_id = COALESCE(p_category_id, category_id),
		min_order_qty = COALESCE(p_min_order_qty, min_order_qty),
		min_stock = COALESCE(p_min_stock, min_stock),
		updated_at = NOW()
	WHERE
		P.id = p_product_id;

	IF p_name IS NOT NULL OR p_description IS NOT NULL THEN
		UPDATE "product_price" AS PP
		SET 
			product_name = COALESCE(p_name, product_name),
			product_description = COALESCE(p_description, product_description),
			updated_at = NOW()	
		WHERE
			PP.product_id = p_product_id;
	END IF;	
END
$$;
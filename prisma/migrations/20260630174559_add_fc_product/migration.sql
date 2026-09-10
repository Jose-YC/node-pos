-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListProducts(
    p_page   	INTEGER,
    p_limit  	INTEGER,           
    p_search 	TEXT DEFAULT NULL
)
RETURNS TABLE (
    id              INTEGER,
    sku             TEXT,
	name            TEXT,
    description     TEXT,
    image           TEXT,
    category_name   TEXT,
    min_order_qty   INTEGER,
    min_stock       INTEGER,
    status          BOOLEAN
)
LANGUAGE sql
AS $$
    SELECT 
		P.id,
		P.sku,
		P.name,
		P.description,
		P.image,
        C.name  AS category_name,
		P.min_order_qty,
		P.min_stock,
		P.status
	FROM "product" AS P
	INNER JOIN "category" AS C ON C.id = P.category_id
    WHERE
        P.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR P.name ILIKE '%' || p_search || '%' 
            OR P.sku ILIKE '%' || p_search || '%'
        )
    ORDER BY P.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListProducts(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "product" AS P
	WHERE 
        P.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR P.name ILIKE '%' || p_search || '%' 
            OR P.sku ILIKE '%' || p_search || '%'
        )
$$;

CREATE OR REPLACE FUNCTION fc_ListCatalogpProducts(
    p_page   	INTEGER,
    p_limit  	INTEGER,           
    p_search 	TEXT DEFAULT NULL,
	p_category 	INTEGER DEFAULT NULL        
)
RETURNS TABLE (
    id              INTEGER,
	name            TEXT,
    image           TEXT,
    category_name   TEXT,
    stock           INTEGER,
    price_selling   NUMERIC(8,2)    
)
LANGUAGE sql
AS $$
    SELECT 
		P.id,
		P.name,
		P.image,
		C.name as category_name,
		PS.stock,
	    PPS.amount AS price_selling
	FROM "product" AS P
	INNER JOIN "product_stock" AS PS ON PS.product_id = P.id
	INNER JOIN "product_price" AS PPS ON PPS.product_id = P.id AND PPS.selling = true
	INNER JOIN "category" AS C ON C.id = P.category_id
    WHERE
        P.status = true AND P.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR P.name ILIKE '%' || p_search || '%' 
            OR P.sku ILIKE '%' || p_search || '%'
        )
		AND (
			p_category IS NULL 
			OR P.category_id = p_category
		)
    ORDER BY P.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListCatalogProducts(
   p_search     TEXT DEFAULT NULL,
   p_category 	INTEGER DEFAULT NULL  
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "product" AS P
	WHERE
        P.status = true AND P.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR P.name ILIKE '%' || p_search || '%' 
            OR P.sku ILIKE '%' || p_search || '%'
        )
		AND (
			p_category IS NULL 
			OR P.category_id = p_category
		)
$$;

CREATE OR REPLACE FUNCTION fc_ProductById(
	p_product_id	INTEGER
)
RETURNS TABLE (
    id              INTEGER,
    sku            TEXT,
    name            TEXT,
    description     TEXT,
    image           TEXT,
    category_id     INTEGER,
    category_name   TEXT,
    min_order_qty   INTEGER,
    min_stock       INTEGER,
    status          BOOLEAN,
    stock           INTEGER,
    price_buying    NUMERIC(8,2),
    price_selling   NUMERIC(8,2)
)	
LANGUAGE sql
STABLE
ROWS 1
AS $$
    SELECT 
        P.id,
        P.sku,
        P.name,
        P.description,
        P.image,
        C.id as category_id,
        C.name as category_name,
        P.min_order_qty,
        P.min_stock,
        P.status,
        PS.stock,
        PPB.amount AS price_buying,
        PPS.amount AS price_selling
    FROM "product" AS P
    INNER JOIN "product_stock" AS PS ON PS.product_id = P.id
    INNER JOIN "product_price" AS PPB  ON PPB.product_id = P.id AND PPB.buying  = true
    INNER JOIN "product_price" AS PPS ON PPS.product_id = P.id AND PPS.selling = true
    INNER JOIN "category" AS C ON C.id = P.category_id
    WHERE P.id = p_product_id AND P.deleted_at IS NULL;
$$;
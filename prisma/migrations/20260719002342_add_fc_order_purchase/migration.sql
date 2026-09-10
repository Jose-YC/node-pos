-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListOrderPurchase(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          	INTEGER,
    serie        	TEXT,
    status        	TEXT,
    supplier_ruc 	TEXT,
    supplier_name 	TEXT,
    delivery_date 	DATE,
    total   		NUMERIC(12,2)        
)
LANGUAGE sql
AS $$
    SELECT
        OP.id,                   
        OP.serie,
        OP.status,
        OP.supplier_ruc,
        OP.supplier_name,
        OP.delivery_date,
        OP.total
	    FROM "order_purchase" AS OP
    WHERE
        OP.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR OP.serie ILIKE '%' || p_search || '%' 
            OR OP.supplier_ruc ILIKE '%' || p_search || '%'
        )
    GROUP BY OP.id, OP.serie, OP.supplier_ruc, OP.total, OP.created_at
    ORDER BY OP.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListOrderPurchase(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "order_purchase" AS OP
    WHERE
		OP.deleted_at IS NULL
		AND ( 
			p_search IS NULL 
			OR OP.serie ILIKE '%' || p_search || '%' 
			OR OP.supplier_ruc ILIKE '%' || p_search || '%'
		)
$$;

-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListReceiptPurchase(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          	INTEGER,
    serie        	TEXT,
	status			TEXT,
	supplier_ruc	TEXT,
	supplier_name	TEXT,
    date_receipt 	TEXT,
    total   		NUMERIC(12,2)        
)
LANGUAGE sql
AS $$
    SELECT
        RP.id,                   
        RP.serie,
		RP.status,
        RP.supplier_ruc,
        RP.supplier_name,
		RP.date_receipt,
        RP.total
	    FROM "receipt_purchase" AS RP
    WHERE
        RP.deleted_at IS NULL
        AND ( 
            p_search IS NULL 
            OR RP.serie ILIKE '%' || p_search || '%' 
            OR RP.supplier_ruc ILIKE '%' || p_search || '%'
        )
    GROUP BY RP.id, RP.serie, RP.status, RP.supplier_ruc, RP.total, RP.created_at
    ORDER BY RP.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListReceiptPurchase(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "receipt_purchase" AS RP
    WHERE
		RP.deleted_at IS NULL
		AND ( 
			p_search IS NULL 
			OR RP.serie ILIKE '%' || p_search || '%' 
			OR RP.supplier_ruc ILIKE '%' || p_search || '%'
		)
$$;	
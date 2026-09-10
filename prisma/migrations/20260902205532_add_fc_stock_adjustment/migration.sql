-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListStockAdjustment(
    p_page   INTEGER,
    p_limit  INTEGER,
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          	                INTEGER,
    serie        	                VARCHAR(13),
    stock_adjustment_date 	        DATE,
    reason_name 	                VARCHAR(200),
    direction 	                    VARCHAR(2),
    total_qty   		            NUMERIC(12,2),       
    total_value   	                NUMERIC(12,2),
    status                          VARCHAR(15)
)       
LANGUAGE sql
AS $$
    SELECT
        SA.id,                   
        SA.serie,
        SA.stock_adjustment_date,
        SA.reason_name,
        SA.direction,
        SA.total_qty,
        SA.total_value,
        SA.status
	    FROM "stock_adjustment" AS SA
    WHERE ( 
            p_search IS NULL 
            OR SA.serie ILIKE '%' || p_search || '%'
        )
    GROUP BY 
            SA.id, SA.serie, SA.stock_adjustment_date, SA.reason_name,
            SA.direction, SA.total_qty, SA.total_value, SA.status, SA.created_at
    ORDER BY SA.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit;
$$;

CREATE OR REPLACE FUNCTION fc_CountListStockAdjustment(
   p_search     TEXT DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "stock_adjustment" AS SA
    WHERE( 
            p_search IS NULL 
            OR SA.serie ILIKE '%' || p_search || '%' 
        )
$$;
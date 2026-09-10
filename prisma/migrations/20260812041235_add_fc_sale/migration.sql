-- This is an empty migration.
CREATE OR REPLACE FUNCTION fc_ListSale(
    p_page   INTEGER,
    p_limit  INTEGER,           
    p_userid INTEGER DEFAULT NULL,
    p_search TEXT DEFAULT NULL 
)
RETURNS TABLE (
    id          	    INTEGER,
    serie        	    VARCHAR(13),
    type_code           VARCHAR(2),
    sale_date 	        DATE,
    customer_name 	    VARCHAR(200),
    customer_doc_code 	VARCHAR(2),
    customer_doc_number VARCHAR(15),

    igv_rate   		    NUMERIC(12,2),       
    taxable_amount   	NUMERIC(12,2),       
    igv_total   		NUMERIC(12,2),       
    total   		    NUMERIC(12,2),       
    paid_amount   		NUMERIC(12,2),       
    change_amount       NUMERIC(12,2),   
    is_return           BOOLEAN,
    return_against_id   INTEGER 
)
LANGUAGE sql
AS $$
    SELECT
        S.id,                   
        S.serie,
        S.type_code,
        S.sale_date,
        S.customer_name,
        S.customer_doc_code,
        S.customer_doc_number,
        S.igv_rate,
        S.taxable_amount,
        S.igv_total,
        S.total,
        S.paid_amount,
        S.change_amount,
        S.is_return,
        S.return_against_id
	    FROM "sale" AS S
    WHERE
        ( 
            p_userid IS NULL OR S.user_id  = p_userid
        )
            AND
        ( 
            p_search IS NULL 
            OR S.serie ILIKE '%' || p_search || '%' 
            OR S.customer_doc_number ILIKE '%' || p_search || '%'
        )
    GROUP BY 
            S.id, S.serie, S.type_code, S.sale_date, S.customer_name, 
            S.customer_doc_code, S.customer_doc_number, S.igv_rate, 
            S.taxable_amount, S.igv_total, S.total, S.paid_amount, 
            S.change_amount, S.is_return, S.return_against_id, S.created_at
    ORDER BY S.created_at DESC
    LIMIT  p_limit
    OFFSET (p_page - 1) * p_limit; 
$$;

CREATE OR REPLACE FUNCTION fc_CountListSale(
   p_search     TEXT DEFAULT NULL,
   p_userid     INTEGER DEFAULT NULL
)
RETURNS INTEGER 
LANGUAGE sql
AS $$
	SELECT
	    COUNT(*) AS total
	FROM "sale" AS S
    WHERE
        ( 
            p_userid IS NULL OR S.user_id  = p_userid
        )
            AND
        ( 
            p_search IS NULL 
            OR S.serie ILIKE '%' || p_search || '%' 
            OR S.customer_doc_number ILIKE '%' || p_search || '%'
        )
$$;
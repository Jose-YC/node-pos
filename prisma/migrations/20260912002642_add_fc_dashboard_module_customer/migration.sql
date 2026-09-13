-- Clientes nuevos del mes actual
CREATE OR REPLACE FUNCTION fc_CustomerDashboardNewThisMonth()
RETURNS INTEGER
LANGUAGE sql
AS $$
    SELECT
        COUNT(*)::INTEGER
    FROM customer
    WHERE deleted_at IS NULL
      AND is_generic = false
      AND created_at >= DATE_TRUNC('month', CURRENT_DATE)
      AND created_at <  DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';
$$;


-- Top clientes por monto de ventas (rango de fechas)
CREATE OR REPLACE FUNCTION fc_CustomerDashboardTopBySales(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    id              INTEGER,
    name            VARCHAR(255),
    document        VARCHAR(255),
    sale_count      INTEGER,
    avg_sale        NUMERIC(12,2),
    amount_total    NUMERIC(12,2),
    last_sale       DATE
)
LANGUAGE sql
AS $$
    SELECT
        c.id,
        c.name,
        c.doc_type_number AS document,
        COUNT(s.id)::INTEGER AS sale_count,
        COALESCE(AVG(s.total), 0)::NUMERIC(12,2) AS avg_sale,
        COALESCE(SUM(s.total), 0)::NUMERIC(12,2) AS amount_total,
        MAX(s.sale_date)::DATE AS last_sale
    FROM customer c
    INNER JOIN sale s ON s.customer_id = c.id
        AND s.deleted_at IS NULL
        AND s.is_return = false
    WHERE c.deleted_at IS NULL
      AND c.is_generic = false
      AND s.sale_date >= from_date
      AND s.sale_date <  to_date + INTERVAL '1 day'
    GROUP BY c.id, c.name, c.doc_type_number
    ORDER BY amount_total DESC;
$$;


-- Clientes inactivos (sin compras en los últimos 30 días)
CREATE OR REPLACE FUNCTION fc_CustomerDashboardInactive()
RETURNS TABLE (
    id                      INTEGER,
    name                    VARCHAR(255),
    document                VARCHAR(255),
    last_sale               DATE,
    days_without_purchase   INTEGER
)
LANGUAGE sql
AS $$
    SELECT
        c.id,
        c.name,
        c.doc_type_number AS document,
        MAX(s.sale_date)::DATE AS last_sale,
        (CURRENT_DATE - MAX(s.sale_date)::DATE)::INTEGER AS days_without_purchase
    FROM customer c
    INNER JOIN sale s ON s.customer_id = c.id
        AND s.deleted_at IS NULL
        AND s.is_return = false
    WHERE c.deleted_at IS NULL
      AND c.is_generic = false
    GROUP BY c.id, c.name, c.doc_type_number
    HAVING MAX(s.sale_date) < CURRENT_DATE - INTERVAL '30 days'
    ORDER BY days_without_purchase DESC;
$$;
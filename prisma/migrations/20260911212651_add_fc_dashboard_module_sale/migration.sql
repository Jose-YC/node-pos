-- KPIs principales del módulo de ventas (rango de fechas)
CREATE OR REPLACE FUNCTION fc_SalesDashboardKPIs(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    net_sales           NUMERIC(12,2),
    average_sale        NUMERIC(12,2),
    num_transactions    BIGINT,
    return_rate_pct     NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        COALESCE(SUM(s.total) FILTER (WHERE s.is_return = false), 0)
        - COALESCE(SUM(s.total) FILTER (WHERE s.is_return = true), 0) AS net_sales,

        COALESCE(
            SUM(s.total) FILTER (WHERE s.is_return = false)
            / NULLIF(COUNT(*) FILTER (WHERE s.is_return = false), 0)
        , 0) AS average_sale,

        COUNT(*) FILTER (WHERE s.is_return = false) AS num_transactions,

        ROUND(
            COALESCE(
                COUNT(*) FILTER (WHERE s.is_return = true)::DECIMAL
                / NULLIF(COUNT(*) FILTER (WHERE s.is_return = false), 0) * 100
            , 0)
        , 2) AS return_rate_pct
    FROM sale s
    WHERE s.deleted_at IS NULL
      AND s.sale_date >= from_date
      AND s.sale_date <  to_date + INTERVAL '1 day';
$$;


-- Tendencia diaria de ventas (rango de fechas)
CREATE OR REPLACE FUNCTION fc_SalesDashboardTrend(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    day                 DATE,
    net_sales           NUMERIC(12,2),
    transactions        BIGINT
)
LANGUAGE sql
AS $$
    SELECT
        DATE_TRUNC('day', s.sale_date)::DATE AS day,
        COALESCE(SUM(s.total) FILTER (WHERE s.is_return = false), 0)
        - COALESCE(SUM(s.total) FILTER (WHERE s.is_return = true), 0) AS net_sales,
        COUNT(*) FILTER (WHERE s.is_return = false) AS transactions
    FROM sale s
    WHERE s.deleted_at IS NULL
      AND s.sale_date >= from_date
      AND s.sale_date <  to_date + INTERVAL '1 day'
    GROUP BY 1
    ORDER BY 1;
$$;


-- Top 10 productos más vendidos (rango de fechas)
CREATE OR REPLACE FUNCTION fc_SalesDashboardTopProducts(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    id                INTEGER,
    product           TEXT,
    qty               INTEGER,
    amount            NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        ds.product_id   AS id,
        ds.product_name AS product,
        SUM(ds.qty)::INTEGER AS qty,
        SUM(ds.subtotal) AS amount
    FROM detail_sale ds
    INNER JOIN sale s ON s.id = ds.sale_id
    WHERE s.deleted_at IS NULL
      AND ds.deleted_at IS NULL
      AND s.is_return = false
      AND s.sale_date >= from_date
      AND s.sale_date <  to_date + INTERVAL '1 day'
    GROUP BY ds.product_id, ds.product_name
    ORDER BY qty DESC
    LIMIT 10;
$$;


-- Ventas por método de pago (rango de fechas)
CREATE OR REPLACE FUNCTION fc_SalesDashboardByPayment(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    payment           TEXT,
    amount            NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        p.name AS payment,
        COALESCE(SUM(sp.amount), 0) AS amount
    FROM payment p
    LEFT JOIN sale_payment sp ON sp.payment_id = p.id
    LEFT JOIN sale s ON s.id = sp.sale_id
        AND s.deleted_at IS NULL
        AND s.is_return = false
        AND s.sale_date >= from_date
        AND s.sale_date <  to_date + INTERVAL '1 day'
    WHERE p.deleted_at IS NULL
      AND p.status = true
    GROUP BY p.id, p.name
    ORDER BY amount DESC;
$$;
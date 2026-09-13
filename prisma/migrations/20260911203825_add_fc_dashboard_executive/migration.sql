-- KPIs de ventas del día (dashboard ejecutivo)
CREATE OR REPLACE FUNCTION fc_DashboardTodaySalesKPIs()
RETURNS TABLE (
    net_sales_today         NUMERIC(12,2),
    sales_average_today     NUMERIC(12,2),
    num_transactions_today  BIGINT,
    return_rate_pct         NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        COALESCE(SUM(s.total) FILTER (WHERE s.is_return = false), 0)
        - COALESCE(SUM(s.total) FILTER (WHERE s.is_return = true), 0) AS net_sales_today,

        COALESCE(
            SUM(s.total) FILTER (WHERE s.is_return = false)
            / NULLIF(COUNT(*) FILTER (WHERE s.is_return = false), 0)
        , 0) AS sales_average_today,

        COUNT(*) FILTER (WHERE s.is_return = false) AS num_transactions_today,

        ROUND(
            COALESCE(
                COUNT(*) FILTER (WHERE s.is_return = true)::DECIMAL
                / NULLIF(COUNT(*) FILTER (WHERE s.is_return = false), 0) * 100
            , 0)
        , 2) AS return_rate_pct
    FROM sale s
    WHERE s.deleted_at IS NULL
      AND s.sale_date >= CURRENT_DATE
      AND s.sale_date <  CURRENT_DATE + INTERVAL '1 day';
$$;

-- Valor total del inventario actual
CREATE OR REPLACE FUNCTION fc_DashboardInventoryValue()
RETURNS NUMERIC(12,2)
LANGUAGE sql
AS $$
    SELECT
        COALESCE(SUM(ps.stock_value), 0)
    FROM "product_stock" ps
    INNER JOIN "product" p ON p.id = ps.product_id
    WHERE p.deleted_at IS NULL
      AND p.status = true;
$$;

-- Tendencia de ventas netas de los últimos 14 días
CREATE OR REPLACE FUNCTION fc_DashboardSalesTrend14d()
RETURNS TABLE (
    day         DATE,
    net_sales   NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        DATE_TRUNC('day', s.sale_date)::DATE AS day,
        COALESCE(SUM(s.total) FILTER (WHERE s.is_return = false), 0)
        - COALESCE(SUM(s.total) FILTER (WHERE s.is_return = true), 0) AS net_sales
    FROM sale s
    WHERE s.deleted_at IS NULL
      AND s.sale_date >= CURRENT_DATE - INTERVAL '13 days'
      AND s.sale_date <  CURRENT_DATE + INTERVAL '1 day'
    GROUP BY 1
    ORDER BY 1;
$$;

-- Top 5 productos más vendidos del día
CREATE OR REPLACE FUNCTION fc_DashboardTopProductsToday()
RETURNS TABLE (
    product     TEXT,
    qty         INTEGER,
    amount      NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        ds.product_name AS product,
        SUM(ds.qty)::INTEGER AS qty,
        SUM(ds.subtotal) AS amount
    FROM detail_sale ds
    INNER JOIN sale s ON s.id = ds.sale_id
    WHERE s.deleted_at IS NULL
      AND ds.deleted_at IS NULL
      AND s.is_return = false
      AND s.sale_date >= CURRENT_DATE
      AND s.sale_date <  CURRENT_DATE + INTERVAL '1 day'
    GROUP BY ds.product_id, ds.product_name
    ORDER BY qty DESC
    LIMIT 5;
$$;

-- Ventas del día por método de pago
CREATE OR REPLACE FUNCTION fc_DashboardSalesByPayment()
RETURNS TABLE (
    payment     TEXT,
    amount      NUMERIC(12,2)
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
        AND s.sale_date >= CURRENT_DATE
        AND s.sale_date <  CURRENT_DATE + INTERVAL '1 day'
    WHERE p.deleted_at IS NULL
      AND p.status = true
    GROUP BY p.id, p.name
    ORDER BY amount DESC;
$$;
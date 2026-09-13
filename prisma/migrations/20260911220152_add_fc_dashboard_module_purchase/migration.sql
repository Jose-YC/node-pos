-- KPIs principales del módulo de compras
CREATE OR REPLACE FUNCTION fc_PurchaseDashboardKPIs()
RETURNS TABLE (
    pending_orders          INTEGER,
    committed_amount        NUMERIC(12,2),
    delayed_orders          INTEGER
)
LANGUAGE sql
AS $$
    SELECT
        COUNT(*) FILTER (WHERE status IN ('enviado', 'aprobado', 'parcial'))::INTEGER AS pending_orders,
        COALESCE(SUM(total) FILTER (WHERE status IN ('enviado', 'aprobado', 'parcial')), 0)::NUMERIC(12,2) AS committed_amount,
        COUNT(*) FILTER (
            WHERE status IN ('enviado', 'aprobado', 'parcial')
              AND delivery_date < CURRENT_DATE
        )::INTEGER AS delayed_orders
    FROM order_purchase
    WHERE deleted_at IS NULL;
$$;


-- Recepciones del mes actual
CREATE OR REPLACE FUNCTION fc_PurchaseDashboardMonthlyReceipts()
RETURNS TABLE (
    receipt_count           INTEGER,
    receipt_amount          NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        COUNT(*)::INTEGER AS receipt_count,
        COALESCE(SUM(total), 0)::NUMERIC(12,2) AS receipt_amount
    FROM receipt_purchase
    WHERE deleted_at IS NULL
      AND status <> 'cancelado'
      AND date_receipt >= DATE_TRUNC('month', CURRENT_DATE)
      AND date_receipt <  DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';
$$;


-- Calidad de recepciones (unidades recibidas / aceptadas / rechazadas)
CREATE OR REPLACE FUNCTION fc_PurchaseDashboardReceiptQuality(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    units_received          INTEGER,
    units_accepted          INTEGER,
    units_rejected          INTEGER,
    rejection_rate_pct      NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        COALESCE(SUM(drp.qty_received), 0) AS units_received,
        COALESCE(SUM(drp.qty_accepted), 0) AS units_accepted,
        COALESCE(SUM(drp.qty_reject), 0) AS units_rejected,
        ROUND(
            COALESCE(SUM(drp.qty_reject)::DECIMAL / NULLIF(SUM(drp.qty_received), 0) * 100, 0)
        , 2) AS rejection_rate_pct
    FROM detail_receipt_purchase drp
    INNER JOIN receipt_purchase rp ON rp.id = drp.receipt_id
    WHERE drp.deleted_at IS NULL
      AND rp.deleted_at IS NULL
      AND rp.status <> 'cancelado'
      AND rp.date_receipt >= from_date
      AND rp.date_receipt <  to_date + INTERVAL '1 day';
$$;


-- Órdenes de compra por estado
CREATE OR REPLACE FUNCTION fc_PurchaseDashboardOrdersByStatus()
RETURNS TABLE (
    status                  TEXT,
    quantity                INTEGER,
    amount                  NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        status,
        COUNT(*)::INTEGER AS quantity,
        COALESCE(SUM(total), 0)::NUMERIC(12,2) AS amount
    FROM order_purchase
    WHERE deleted_at IS NULL
    GROUP BY status
    ORDER BY quantity DESC;
$$;


-- Top proveedores por monto (rango de fechas)
CREATE OR REPLACE FUNCTION fc_PurchaseDashboardTopSuppliers(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    supplier_id             INTEGER,
    supplier_name           TEXT,
    order_count             INTEGER,
    total_amount            NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        supplier_id,
        supplier_name,
        COUNT(*)::INTEGER AS order_count,
        COALESCE(SUM(total), 0)::NUMERIC(12,2) AS total_amount
    FROM order_purchase
    WHERE deleted_at IS NULL
      AND status <> 'cancelado'
      AND created_at >= from_date
      AND created_at <  to_date + INTERVAL '1 day'
    GROUP BY supplier_id, supplier_name
    ORDER BY total_amount DESC;
$$;
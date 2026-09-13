-- KPIs principales del módulo de inventario
CREATE OR REPLACE FUNCTION fc_InventoryDashboardKPIs()
RETURNS TABLE (
    total_inventory_value       NUMERIC(12,2),
    products_out_of_stock       INTEGER,
    products_below_min          INTEGER
)
LANGUAGE sql
AS $$
    SELECT
        COALESCE(SUM(ps.stock_value), 0)::NUMERIC(12,2) AS total_inventory_value,
        COUNT(*) FILTER (WHERE ps.stock = 0)::INTEGER AS products_out_of_stock,
        COUNT(*) FILTER (WHERE ps.stock > 0 AND ps.stock < p.min_stock)::INTEGER AS products_below_min
    FROM product p
    INNER JOIN product_stock ps ON ps.product_id = p.id
    WHERE p.deleted_at IS NULL
      AND p.status = true;
$$;


-- Productos bajo el stock mínimo
CREATE OR REPLACE FUNCTION fc_InventoryDashboardLowStock()
RETURNS TABLE (
    id                  INTEGER,
    sku                 TEXT,
    name                TEXT,
    min_stock           INTEGER,
    stock               INTEGER,
    deficit             INTEGER,
    stock_value         NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        p.id,
        p.sku,
        p.name,
        p.min_stock,
        ps.stock,
        (p.min_stock - ps.stock)::INTEGER AS deficit,
        ps.stock_value
    FROM product p
    INNER JOIN product_stock ps ON ps.product_id = p.id
    WHERE p.deleted_at IS NULL
      AND p.status = true
      AND ps.stock < p.min_stock
    ORDER BY deficit DESC;
$$;


-- Productos sin movimiento en los últimos 30 días
CREATE OR REPLACE FUNCTION fc_InventoryDashboardNoMovement()
RETURNS TABLE (
    id                  INTEGER,
    sku                 TEXT,
    name                TEXT,
    stock               INTEGER,
    stock_value         NUMERIC(12,2),
    last_movement       DATE
)
LANGUAGE sql
AS $$
    SELECT
        p.id,
        p.sku,
        p.name,
        ps.stock,
        ps.stock_value,
        MAX(k.kardex_date)::DATE AS last_movement
    FROM product p
    LEFT JOIN kardex k ON k.product_id = p.id AND k.deleted_at IS NULL
    LEFT JOIN product_stock ps ON ps.product_id = p.id
    WHERE p.deleted_at IS NULL
      AND p.status = true
    GROUP BY p.id, p.sku, p.name, ps.stock, ps.stock_value
    HAVING MAX(k.kardex_date) IS NULL
        OR MAX(k.kardex_date) < CURRENT_DATE - INTERVAL '30 days'
    ORDER BY ps.stock_value DESC NULLS LAST;
$$;


-- Inventario agrupado por categoría
CREATE OR REPLACE FUNCTION fc_InventoryDashboardByCategory()
RETURNS TABLE (
    category            TEXT,
    num_products        INTEGER,
    units               INTEGER,
    value               NUMERIC(12,2)
)
LANGUAGE sql
AS $$
    SELECT
        c.name AS category,
        COUNT(p.id)::INTEGER AS num_products,
        COALESCE(SUM(ps.stock), 0)::INTEGER AS units,
        COALESCE(SUM(ps.stock_value), 0)::NUMERIC(12,2) AS value
    FROM category c
    INNER JOIN product p ON p.category_id = c.id 
        AND p.deleted_at IS NULL 
        AND p.status = true
    INNER JOIN product_stock ps ON ps.product_id = p.id
    WHERE c.deleted_at IS NULL
    GROUP BY c.id, c.name
    ORDER BY value DESC;
$$;


-- Tendencia de movimientos de inventario
CREATE OR REPLACE FUNCTION fc_InventoryDashboardMovementTrend(
    from_date   DATE,
    to_date     DATE
)
RETURNS TABLE (
    day                 DATE,
    units_in            INTEGER,
    units_out           INTEGER
)
LANGUAGE sql
AS $$
    SELECT
        k.kardex_date::DATE AS day,
        COALESCE(SUM(CASE WHEN k.type = 'IN'  THEN k.after_qty - k.actual_qty ELSE 0 END), 0)::INTEGER AS units_in,
        COALESCE(SUM(CASE WHEN k.type = 'OUT' THEN k.actual_qty - k.after_qty ELSE 0 END), 0)::INTEGER AS units_out
    FROM kardex k
    WHERE k.deleted_at IS NULL
      AND k.kardex_date >= from_date
      AND k.kardex_date <  to_date + INTERVAL '1 day'
    GROUP BY 1
    ORDER BY 1;
$$;
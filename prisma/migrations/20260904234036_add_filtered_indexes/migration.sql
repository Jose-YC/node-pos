-- Índices de rendimiento para claves foráneas, joins y listados frecuentes.
-- Se usa IF NOT EXISTS para permitir una ejecución idempotente.

-- Relaciones RBAC
CREATE INDEX IF NOT EXISTS "user_role_role_id_deleted_at_idx"
  ON "user_role" ("role_id", "deleted_at");

CREATE INDEX IF NOT EXISTS "role_permission_permission_id_deleted_at_idx"
  ON "role_permission" ("permission_id", "deleted_at");

-- Catálogo y clientes
CREATE INDEX IF NOT EXISTS "customer_doc_type_code_idx"
  ON "customer" ("doc_type_code");

CREATE INDEX IF NOT EXISTS "product_category_id_idx"
  ON "product" ("category_id");

CREATE INDEX IF NOT EXISTS "product_status_deleted_at_idx"
  ON "product" ("status", "deleted_at");

CREATE INDEX IF NOT EXISTS "product_price_product_id_buying_selling_idx"
  ON "product_price" ("product_id", "buying", "selling");

CREATE INDEX IF NOT EXISTS "product_stock_product_id_idx"
  ON "product_stock" ("product_id");

-- Órdenes de compra
CREATE INDEX IF NOT EXISTS "order_purchase_user_id_idx"
  ON "order_purchase" ("user_id");

CREATE INDEX IF NOT EXISTS "order_purchase_supplier_id_idx"
  ON "order_purchase" ("supplier_id");

CREATE INDEX IF NOT EXISTS "order_purchase_status_created_at_idx"
  ON "order_purchase" ("status", "created_at" DESC);

CREATE INDEX IF NOT EXISTS "order_purchase_delivery_date_idx"
  ON "order_purchase" ("delivery_date");

CREATE INDEX IF NOT EXISTS "detail_order_purchase_purchase_id_idx"
  ON "detail_order_purchase" ("purchase_id");

-- Kardex
CREATE INDEX IF NOT EXISTS "kardex_product_id_kardex_date_idx"
  ON "kardex" ("product_id", "kardex_date" DESC);

CREATE INDEX IF NOT EXISTS "kardex_doc_type_doc_id_idx"
  ON "kardex" ("doc_type", "doc_id");

-- Recepciones de compra
CREATE INDEX IF NOT EXISTS "receipt_purchase_user_id_idx"
  ON "receipt_purchase" ("user_id");

CREATE INDEX IF NOT EXISTS "receipt_purchase_purchase_id_idx"
  ON "receipt_purchase" ("purchase_id");

CREATE INDEX IF NOT EXISTS "receipt_purchase_supplier_id_idx"
  ON "receipt_purchase" ("supplier_id");

CREATE INDEX IF NOT EXISTS "receipt_purchase_status_created_at_idx"
  ON "receipt_purchase" ("status", "created_at" DESC);

CREATE INDEX IF NOT EXISTS "receipt_purchase_date_receipt_idx"
  ON "receipt_purchase" ("date_receipt" DESC);

CREATE INDEX IF NOT EXISTS "detail_receipt_purchase_receipt_id_idx"
  ON "detail_receipt_purchase" ("receipt_id");

CREATE INDEX IF NOT EXISTS "detail_receipt_purchase_detail_purchase_id_idx"
  ON "detail_receipt_purchase" ("detail_purchase_id");

CREATE INDEX IF NOT EXISTS "detail_receipt_purchase_product_id_idx"
  ON "detail_receipt_purchase" ("product_id");

-- Apertura y cierre de caja
CREATE INDEX IF NOT EXISTS "box_open_user_id_idx"
  ON "box_open" ("user_id");

CREATE INDEX IF NOT EXISTS "box_open_status_start_date_idx"
  ON "box_open" ("status", "start_date" DESC);

CREATE INDEX IF NOT EXISTS "detail_box_open_box_open_id_idx"
  ON "detail_box_open" ("box_open_id");

CREATE INDEX IF NOT EXISTS "detail_box_open_mode_payment_idx"
  ON "detail_box_open" ("mode_payment");

CREATE INDEX IF NOT EXISTS "box_closed_user_id_idx"
  ON "box_closed" ("user_id");

CREATE INDEX IF NOT EXISTS "box_closed_box_open_id_idx"
  ON "box_closed" ("box_open_id");

CREATE INDEX IF NOT EXISTS "box_closed_status_end_date_idx"
  ON "box_closed" ("status", "end_date" DESC);

CREATE INDEX IF NOT EXISTS "detail_box_closed_box_closed_id_idx"
  ON "detail_box_closed" ("box_closed_id");

CREATE INDEX IF NOT EXISTS "detail_box_closed_mode_payment_idx"
  ON "detail_box_closed" ("mode_payment");

-- Ventas
CREATE INDEX IF NOT EXISTS "sale_user_id_sale_date_idx"
  ON "sale" ("user_id", "sale_date" DESC);

CREATE INDEX IF NOT EXISTS "sale_box_open_id_sale_date_idx"
  ON "sale" ("box_open_id", "sale_date" DESC);

CREATE INDEX IF NOT EXISTS "sale_customer_id_idx"
  ON "sale" ("customer_id");

CREATE INDEX IF NOT EXISTS "sale_type_code_idx"
  ON "sale" ("type_code");

CREATE INDEX IF NOT EXISTS "sale_return_against_id_idx"
  ON "sale" ("return_against_id");

CREATE INDEX IF NOT EXISTS "detail_sale_sale_id_idx"
  ON "detail_sale" ("sale_id");

CREATE INDEX IF NOT EXISTS "detail_sale_product_id_idx"
  ON "detail_sale" ("product_id");

CREATE INDEX IF NOT EXISTS "sale_payment_sale_id_idx"
  ON "sale_payment" ("sale_id");

CREATE INDEX IF NOT EXISTS "sale_payment_box_open_id_idx"
  ON "sale_payment" ("box_open_id");

CREATE INDEX IF NOT EXISTS "sale_payment_payment_id_idx"
  ON "sale_payment" ("payment_id");

-- Ajustes de stock
CREATE INDEX IF NOT EXISTS "reason_status_idx"
  ON "reason" ("status");

CREATE INDEX IF NOT EXISTS "stock_adjustment_user_id_idx"
  ON "stock_adjustment" ("user_id");

CREATE INDEX IF NOT EXISTS "stock_adjustment_reason_id_idx"
  ON "stock_adjustment" ("reason_id");

CREATE INDEX IF NOT EXISTS "stock_adjustment_status_date_idx"
  ON "stock_adjustment" ("status", "stock_adjustment_date" DESC);

CREATE INDEX IF NOT EXISTS "detail_stock_adjustment_adjustment_id_idx"
  ON "detail_stock_adjustment" ("stock_adjustment_id");

CREATE INDEX IF NOT EXISTS "detail_stock_adjustment_product_id_idx"
  ON "detail_stock_adjustment" ("product_id");

-- Listados activos: índices parciales para evitar indexar registros eliminados.
CREATE INDEX IF NOT EXISTS "user_active_created_at_idx"
  ON "user" ("created_at" DESC)
  WHERE "deleted_at" IS NULL;

CREATE INDEX IF NOT EXISTS "category_active_created_at_idx"
  ON "category" ("created_at" DESC)
  WHERE "deleted_at" IS NULL;

CREATE INDEX IF NOT EXISTS "supplier_active_created_at_idx"
  ON "supplier" ("created_at" DESC)
  WHERE "deleted_at" IS NULL;

CREATE INDEX IF NOT EXISTS "sale_active_sale_date_idx"
  ON "sale" ("sale_date" DESC)
  WHERE "deleted_at" IS NULL;

CREATE INDEX IF NOT EXISTS "stock_adjustment_active_date_idx"
  ON "stock_adjustment" ("stock_adjustment_date" DESC)
  WHERE "deleted_at" IS NULL;

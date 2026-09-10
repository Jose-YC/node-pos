-- CreateTable
CREATE TABLE "order_purchase" (
    "id" SERIAL NOT NULL,
    "serie" TEXT NOT NULL,
    "supplier_id" INTEGER NOT NULL,
    "supplier_name" TEXT NOT NULL,
    "supplier_ruc" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "address_purchase" TEXT NOT NULL,
    "delivery_date" DATE NOT NULL,
    "total" DECIMAL(12,2) NOT NULL,
    "user_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "order_purchase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detail_order_purchase" (
    "id" SERIAL NOT NULL,
    "purchase_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "product_name" TEXT NOT NULL,
    "qty_received" INTEGER NOT NULL,
    "qty" INTEGER NOT NULL, 
    "price" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "detail_order_purchase_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "order_purchase" ADD CONSTRAINT "order_purchase_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_purchase" ADD CONSTRAINT "order_purchase_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "supplier"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_order_purchase" ADD CONSTRAINT "detail_order_purchase_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "order_purchase"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_order_purchase" ADD CONSTRAINT "detail_order_purchase_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE IF NOT EXISTS order_purchase_serie START 1;
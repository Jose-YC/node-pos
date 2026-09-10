/*
  Warnings:

  - A unique constraint covering the columns `[product_id,purchase_id]` on the table `detail_order_purchase` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateTable
CREATE TABLE "receipt_purchase" (
    "id" SERIAL NOT NULL,
    "serie" TEXT NOT NULL,
    "purchase_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "supplier_id" INTEGER NOT NULL,
    "supplier_name" TEXT NOT NULL,
    "supplier_ruc" TEXT NOT NULL,
    "date_receipt" DATE NOT NULL,
    "note" TEXT,
    "total" DECIMAL(12,2) NOT NULL,
    "user_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "receipt_purchase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detail_receipt_purchase" (
    "id" SERIAL NOT NULL,
    "receipt_id" INTEGER NOT NULL,
    "detail_purchase_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "product_name" TEXT NOT NULL,
    "qty_received" INTEGER NOT NULL,
    "qty_reject" INTEGER NOT NULL,
    "qty_accepted" INTEGER NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "detail_receipt_purchase_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "detail_order_purchase_product_id_purchase_id_key" ON "detail_order_purchase"("product_id", "purchase_id");

-- AddForeignKey
ALTER TABLE "receipt_purchase" ADD CONSTRAINT "receipt_purchase_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipt_purchase" ADD CONSTRAINT "receipt_purchase_purchase_id_fkey" FOREIGN KEY ("purchase_id") REFERENCES "order_purchase"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipt_purchase" ADD CONSTRAINT "receipt_purchase_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "supplier"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_receipt_purchase" ADD CONSTRAINT "detail_receipt_purchase_detail_purchase_id_fkey" FOREIGN KEY ("detail_purchase_id") REFERENCES "detail_order_purchase"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_receipt_purchase" ADD CONSTRAINT "detail_receipt_purchase_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "receipt_purchase"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_receipt_purchase" ADD CONSTRAINT "detail_receipt_purchase_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE IF NOT EXISTS receipt_purchase_serie START 1;
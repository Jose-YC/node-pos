-- CreateTable
CREATE TABLE "stock_adjustment" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "serie" VARCHAR(20) NOT NULL,
    "stock_adjustment_date" TIMESTAMP(3) NOT NULL,
    "reason_id" INTEGER NOT NULL,
    "reason_name" TEXT NOT NULL,
    "direction" TEXT NOT NULL,
    "notes" TEXT,
    "status" TEXT NOT NULL,
    "total_qty" INTEGER NOT NULL,
    "total_value" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "stock_adjustment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detail_stock_adjustment" (
    "id" SERIAL NOT NULL,
    "stock_adjustment_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "product_name" TEXT NOT NULL,
    "qty" INTEGER NOT NULL,
    "valuation_rate" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "detail_stock_adjustment_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "stock_adjustment" ADD CONSTRAINT "stock_adjustment_reason_id_fkey" FOREIGN KEY ("reason_id") REFERENCES "reason"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_adjustment" ADD CONSTRAINT "stock_adjustment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_stock_adjustment" ADD CONSTRAINT "detail_stock_adjustment_stock_adjustment_id_fkey" FOREIGN KEY ("stock_adjustment_id") REFERENCES "stock_adjustment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_stock_adjustment" ADD CONSTRAINT "detail_stock_adjustment_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE IF NOT EXISTS stock_adjustment_in_serie START 1;
CREATE SEQUENCE IF NOT EXISTS stock_adjustment_out_serie START 1;
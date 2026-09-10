-- CreateTable
CREATE TABLE "kardex" (
    "id" SERIAL NOT NULL,
    "kardex_date" DATE NOT NULL,
    "product_id" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "doc_id" INTEGER NOT NULL,
    "doc_type" TEXT NOT NULL,
    "doc_serie" TEXT NOT NULL,
    "actual_qty" INTEGER NOT NULL,
    "after_qty" INTEGER NOT NULL,
    "incoming_rate" DECIMAL(12,2) NOT NULL,
    "outgoing_rate" DECIMAL(12,2) NOT NULL,
    "valuation_rate" DECIMAL(12,2) NOT NULL,
    "stock_value" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "kardex_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "kardex" ADD CONSTRAINT "kardex_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

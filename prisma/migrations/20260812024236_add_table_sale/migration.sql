/*
  Warnings:

  - You are about to drop the column `box_id` on the `detail_box_open` table. All the data in the column will be lost.
  - Added the required column `box_open_id` to the `detail_box_open` table without a default value. This is not possible if the table is not empty.
*/

-- CreateTable
CREATE TABLE "type_document_sale" (
    "id" VARCHAR(2) NOT NULL,
    "code" VARCHAR(2) NOT NULL,
    "name" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "type_document_sale_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sale" (
    "id" SERIAL NOT NULL,
    "serie" VARCHAR(13) NOT NULL,
    "box_open_id" INTEGER NOT NULL,
    "type_code" VARCHAR(2) NOT NULL,
    "user_id" INTEGER NOT NULL,
    "sale_date" TIMESTAMP(3) NOT NULL,

    "customer_id" INTEGER,                              -- nullable
    "customer_name" VARCHAR(200) NOT NULL,
    "customer_doc_code" VARCHAR(2) NOT NULL,            -- 01, 06, etc.
    "customer_doc_number" VARCHAR(15) NOT NULL,

    "igv_rate" DECIMAL(12,2) NOT NULL,
    "taxable_amount" DECIMAL(12,2) NOT NULL,
    "igv_total" DECIMAL(12,2) NOT NULL,
    "total" DECIMAL(12,2) NOT NULL,
    "paid_amount" DECIMAL(12,2) NOT NULL,
    "change_amount" DECIMAL(12,2) NOT NULL,

    "is_return" BOOLEAN NOT NULL DEFAULT false,
    "return_against_id" INTEGER,

    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "sale_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detail_sale" (
    "id" SERIAL NOT NULL,
    "sale_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "product_name" TEXT NOT NULL,
    "qty" INTEGER NOT NULL,
    "valuation_rate" DECIMAL(12,2) NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "detail_sale_pkey" PRIMARY KEY ("id")
);

-- CreateTable
-- CreateTable
CREATE TABLE "sale_payment" (
    "id" SERIAL NOT NULL,
    "sale_id" INTEGER NOT NULL,
    "box_open_id" INTEGER NOT NULL,
    "payment_id" INTEGER NOT NULL,
    "payment_name" TEXT NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "sale_payment_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey (sale)
ALTER TABLE "sale" ADD CONSTRAINT "sale_type_code_fkey" FOREIGN KEY ("type_code") REFERENCES "type_document_sale"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sale" ADD CONSTRAINT "sale_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sale" ADD CONSTRAINT "sale_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sale" ADD CONSTRAINT "sale_box_open_id_fkey" FOREIGN KEY ("box_open_id") REFERENCES "box_open"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sale" ADD CONSTRAINT "sale_return_against_id_fkey" FOREIGN KEY ("return_against_id") REFERENCES "sale"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey (detail_sale)
ALTER TABLE "detail_sale" ADD CONSTRAINT "detail_sale_sale_id_fkey" FOREIGN KEY ("sale_id") REFERENCES "sale"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "detail_sale" ADD CONSTRAINT "detail_sale_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey (sale_payment)
ALTER TABLE "sale_payment" ADD CONSTRAINT "sale_payment_sale_id_fkey" FOREIGN KEY ("sale_id") REFERENCES "sale"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sale_payment" ADD CONSTRAINT "sale_payment_box_open_id_fkey" FOREIGN KEY ("box_open_id") REFERENCES "box_open"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sale_payment" ADD CONSTRAINT "sale_payment_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE IF NOT EXISTS sale_factura_serie START 1;
CREATE SEQUENCE IF NOT EXISTS sale_boleta_serie START 1;
CREATE SEQUENCE IF NOT EXISTS nota_credito_serie START 1;
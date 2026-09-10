-- CreateTable
CREATE TABLE "box_open" (
    "id" SERIAL NOT NULL,
    "serie" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "box_open_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detail_box_open" (
    "id" SERIAL NOT NULL,
    "box_open_id" INTEGER NOT NULL,
    "mode_payment" INTEGER NOT NULL,
    "opening_amount" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "detail_box_open_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "box_closed" (
    "id" SERIAL NOT NULL,
    "serie" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "box_open_id" INTEGER NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "box_closed_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detail_box_closed" (
    "id" SERIAL NOT NULL,
    "box_closed_id" INTEGER NOT NULL,
    "mode_payment" INTEGER NOT NULL,
    "mode_payment_name" TEXT NOT NULL,
    "opening_amount" DECIMAL(12,2) NOT NULL,
    "expected_amount" DECIMAL(12,2) NOT NULL,
    "closing_amount" DECIMAL(12,2) NOT NULL,
    "difference_amount" DECIMAL(12,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "detail_box_closed_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "box_open" ADD CONSTRAINT "box_open_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_box_open" ADD CONSTRAINT "detail_box_open_box_open_id_fkey" FOREIGN KEY ("box_open_id") REFERENCES "box_open"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_box_open" ADD CONSTRAINT "detail_box_open_mode_payment_fkey" FOREIGN KEY ("mode_payment") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "box_closed" ADD CONSTRAINT "box_closed_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "box_closed" ADD CONSTRAINT "box_closed_box_open_id_fkey" FOREIGN KEY ("box_open_id") REFERENCES "box_open"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_box_closed" ADD CONSTRAINT "detail_box_closed_box_closed_id_fkey" FOREIGN KEY ("box_closed_id") REFERENCES "box_closed"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detail_box_closed" ADD CONSTRAINT "detail_box_closed_mode_payment_fkey" FOREIGN KEY ("mode_payment") REFERENCES "payment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE SEQUENCE IF NOT EXISTS open_box_serie START 1;
CREATE SEQUENCE IF NOT EXISTS closed_box_serie START 1;
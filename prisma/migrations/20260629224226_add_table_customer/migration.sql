-- CreateTable
CREATE TABLE "customer" (
    "id" SERIAL NOT NULL,
    "doc_type_code" TEXT NOT NULL,
    "doc_type_name" TEXT NOT NULL,
    "doc_type_number" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_generic" BOOLEAN NOT NULL DEFAULT false,
    "email" TEXT,
    "phone" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "customer_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "customer_doc_type_number_key" ON "customer"("doc_type_number");

-- AddForeignKey
ALTER TABLE "customer" ADD CONSTRAINT "customer_doc_type_code_fkey" 
FOREIGN KEY ("doc_type_code") REFERENCES "identity_document_type"("id") 
ON DELETE RESTRICT ON UPDATE CASCADE;
import { prisma } from "../config";
import { readFileSync } from "fs";
import { join } from "path";          // ← Agrega esta línea

async function clean() {
  console.log("Limpiando datos...");

  await prisma.$executeRawUnsafe(`
    TRUNCATE TABLE 
      "detail_stock_adjustment", "stock_adjustment",
      "sale_payment", "detail_sale", "sale",
      "detail_box_closed", "box_closed",
      "detail_box_open", "box_open",
      "detail_receipt_purchase", "receipt_purchase",
      "detail_order_purchase", "order_purchase",
      "kardex", "product_stock", "product_price", "product",
      "customer", "supplier", "category",
      "user_role", "role_permission", "user", "role"
    RESTART IDENTITY CASCADE;
  `);

  console.log("✅ Limpieza completada correctamente");
}

async function main() {
  console.log("🌱 Ejecutando seed SQL...");

  const sqlPath = join(__dirname, "db-seed.sql");
  const sql = readFileSync(sqlPath, "utf-8");

  // Ejecuta todo el script de una sola vez
  await prisma.$executeRawUnsafe(sql);

  console.log("✅ Seed completado correctamente");
}

main()
  .catch((e) => {
    console.error("❌ Error en el seed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
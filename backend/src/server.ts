import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";

dotenv.config();

const app = express();
const prisma = new PrismaClient();

const corsOrigin = process.env.CORS_ORIGIN || "*";
app.use(cors({ origin: corsOrigin }));
app.use(express.json({ limit: "1mb" }));

app.get("/api/health", async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ ok: true, app: "Sa3r", version: "0.3.0", database: "connected" });
  } catch {
    res.status(503).json({ ok: false, app: "Sa3r", database: "unavailable" });
  }
});

app.get("/api/products", async (req, res) => {
  try {
    const q = String(req.query.q ?? "").trim();
    const products = await prisma.product.findMany({
      where: q ? {
        OR: [
          { name: { contains: q, mode: "insensitive" } },
          { brand: { contains: q, mode: "insensitive" } },
          { model: { contains: q, mode: "insensitive" } }
        ]
      } : undefined,
      include: { offers: { include: { store: true } } },
      take: 50
    });
    res.json(products);
  } catch {
    res.status(500).json({ error: "Database error" });
  }
});

app.get("/api/products/:id", async (req, res) => {
  try {
    const product = await prisma.product.findUnique({
      where: { id: req.params.id },
      include: {
        offers: { include: { store: true } },
        priceHistory: { orderBy: { recordedAt: "desc" }, take: 100 }
      }
    });
    if (!product) return res.status(404).json({ error: "Product not found" });
    res.json(product);
  } catch {
    res.status(500).json({ error: "Database error" });
  }
});

app.post("/api/alerts", async (req, res) => {
  try {
    const { userId, productId, targetPrice } = req.body;
    if (!userId || !productId || !targetPrice) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    const alert = await prisma.priceAlert.create({
      data: { userId, productId, targetPrice: Number(targetPrice) }
    });
    res.status(201).json(alert);
  } catch {
    res.status(500).json({ error: "Could not create alert" });
  }
});

app.post("/api/ai/ask", async (req, res) => {
  const question = String(req.body.question ?? "").trim();
  res.json({
    answer: process.env.AI_API_KEY
      ? "AI provider is configured; connect the provider adapter here."
      : `تم استلام سؤالك: "${question}". أضف AI_API_KEY لتفعيل مزود الذكاء الاصطناعي.`
  });
});

const port = Number(process.env.PORT || 4000);
app.listen(port, () => console.log(`Sa3r API listening on ${port}`));

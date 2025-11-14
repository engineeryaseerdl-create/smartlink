import express from "express";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";
import productRoutes from "./routes/productRoutes.js";
import buyerRoutes from "./routes/buyerRoutes.js";
import sellerRoutes from "./routes/sellerRoutes.js";
import riderRoutes from "./routes/riderRoutes.js";
import adminRoutes from "./routes/adminRoutes.js";
import { errorHandler } from "./middleware/errorMiddleware.js";

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/buyers", buyerRoutes);
app.use("/api/sellers", sellerRoutes);
app.use("/api/riders", riderRoutes);
app.use("/api/admin", adminRoutes);

// Error Handling
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`SmartLink API running on port ${PORT}`));

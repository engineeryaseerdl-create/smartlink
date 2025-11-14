import mongoose from "mongoose";

const orderSchema = mongoose.Schema({
  buyerId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  sellerId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  riderId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  productId: { type: mongoose.Schema.Types.ObjectId, ref: "Product" },
  total: Number,
  status: {
    type: String,
    enum: ["pending", "assigned", "picked", "delivered", "cancelled"],
    default: "pending",
  },
  deliveryMode: { type: String, enum: ["local", "interstate"] },
}, { timestamps: true });

export default mongoose.model("Order", orderSchema);

import mongoose from "mongoose";

const productSchema = mongoose.Schema({
  sellerId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  name: String,
  category: String,
  description: String,
  images: [String],
  price: Number,
  stock: Number,
  location: String,
}, { timestamps: true });

export default mongoose.model("Product", productSchema);

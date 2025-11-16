"use client"

import { motion } from 'framer-motion';
import { Star, TrendingUp } from 'lucide-react';

const topProducts = [
  { name: "iPhone 14 Pro Max", sales: 234, revenue: "₦2,340,000", trend: "+12%", rating: 4.8 },
  { name: "Samsung Galaxy S23", sales: 189, revenue: "₦1,890,000", trend: "+8%", rating: 4.6 },
  { name: "MacBook Pro M2", sales: 156, revenue: "₦4,680,000", trend: "+15%", rating: 4.9 },
  { name: "AirPods Pro", sales: 312, revenue: "₦936,000", trend: "+20%", rating: 4.7 },
  { name: "iPad Air", sales: 145, revenue: "₦2,175,000", trend: "+5%", rating: 4.5 },
];

export default function TopProducts({ isDarkMode }: { isDarkMode: boolean }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.4 }}
      className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl p-6`}
    >
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className={`text-xl font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>Top Products</h2>
          <p className="text-sm text-gray-400 mt-1">Best selling items</p>
        </div>
        <TrendingUp className="w-5 h-5 text-orange-500" />
      </div>
      <div className="space-y-4">
        {topProducts.map((product, index) => (
          <motion.div
            key={product.name}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.5 + index * 0.1 }}
            className={`p-4 rounded-xl ${isDarkMode ? 'bg-gray-800/50 hover:bg-gray-800' : 'bg-gray-50 hover:bg-gray-100'} transition-all cursor-pointer group`}
          >
            <div className="flex items-center justify-between mb-2">
              <h3 className={`font-semibold ${isDarkMode ? 'text-white' : 'text-gray-900'} group-hover:text-orange-500 transition-colors`}>
                {product.name}
              </h3>
              <span className="text-xs font-bold text-green-500 bg-green-500/20 px-2 py-1 rounded-full">
                {product.trend}
              </span>
            </div>
            <div className="flex items-center justify-between text-sm">
              <div className="flex items-center gap-4">
                <span className="text-gray-400">{product.sales} sales</span>
                <div className="flex items-center gap-1">
                  <Star className="w-4 h-4 text-yellow-500 fill-yellow-500" />
                  <span className="text-gray-400">{product.rating}</span>
                </div>
              </div>
              <span className={`font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>
                {product.revenue}
              </span>
            </div>
          </motion.div>
        ))}
      </div>
    </motion.div>
  );
}

"use client"

import { motion } from 'framer-motion';
import { DollarSign, Users, ShoppingCart, TrendingUp, ArrowUp, ArrowDown, Sparkles } from 'lucide-react';

const stats = [
  {
    title: "Total Revenue",
    value: "₦12,475,320",
    change: "+23.5%",
    trend: "up",
    icon: DollarSign,
    color: "text-emerald-500",
    bgColor: "bg-emerald-500/10",
    borderColor: "border-emerald-500/20",
    shadowColor: "shadow-emerald-500/20",
  },
  {
    title: "Active Users",
    value: "54,239",
    change: "+12.2%",
    trend: "up",
    icon: Users,
    color: "text-blue-500",
    bgColor: "bg-blue-500/10",
    borderColor: "border-blue-500/20",
    shadowColor: "shadow-blue-500/20",
  },
  {
    title: "Total Orders",
    value: "12,847",
    change: "+18.4%",
    trend: "up",
    icon: ShoppingCart,
    color: "text-orange-500",
    bgColor: "bg-orange-500/10",
    borderColor: "border-orange-500/20",
    shadowColor: "shadow-orange-500/20",
  },
  {
    title: "Conversion Rate",
    value: "3.47%",
    change: "+8.1%",
    trend: "up",
    icon: TrendingUp,
    color: "text-purple-500",
    bgColor: "bg-purple-500/10",
    borderColor: "border-purple-500/20",
    shadowColor: "shadow-purple-500/20",
  },
];

export default function StatsGrid({ isDarkMode }: { isDarkMode: boolean }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      {stats.map((stat, index) => (
        <motion.div
          key={stat.title}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: index * 0.1 }}
          whileHover={{ y: -5, transition: { duration: 0.2 } }}
          className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl p-6 relative overflow-hidden group cursor-pointer`}
        >
          <div className={`absolute inset-0 bg-gradient-to-br ${stat.bgColor} opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>
          <div className="relative z-10">
            <div className="flex items-center justify-between mb-4">
              <div className={`w-14 h-14 ${stat.bgColor} ${stat.borderColor} border rounded-2xl flex items-center justify-center shadow-lg ${stat.shadowColor} group-hover:scale-110 transition-transform duration-300`}>
                <stat.icon className={`w-7 h-7 ${stat.color}`} />
              </div>
              <div className={`flex items-center gap-1.5 px-2.5 py-1 rounded-full text-sm font-semibold ${
                stat.trend === 'up' ? 'bg-green-500/20 text-green-500' : 'bg-red-500/20 text-red-500'
              }`}>
                {stat.trend === 'up' ? <ArrowUp className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
                <span>{stat.change}</span>
              </div>
            </div>
            <h3 className={`text-3xl font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'} mb-1`}>
              {stat.value}
            </h3>
            <p className={`${isDarkMode ? 'text-gray-400' : 'text-gray-600'} text-sm font-medium`}>
              {stat.title}
            </p>
          </div>
          <Sparkles className={`absolute -bottom-2 -right-2 w-20 h-20 ${stat.color} opacity-5 group-hover:opacity-10 transition-opacity`} />
        </motion.div>
      ))}
    </div>
  );
}

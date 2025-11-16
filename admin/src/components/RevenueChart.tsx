"use client"

import { motion } from 'framer-motion';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { TrendingUp, Calendar } from 'lucide-react';

const data = [
  { name: 'Jan', revenue: 4000, orders: 240 },
  { name: 'Feb', revenue: 3000, orders: 198 },
  { name: 'Mar', revenue: 5000, orders: 320 },
  { name: 'Apr', revenue: 4500, orders: 278 },
  { name: 'May', revenue: 6000, orders: 389 },
  { name: 'Jun', revenue: 5500, orders: 349 },
  { name: 'Jul', revenue: 7000, orders: 430 },
];

export default function RevenueChart({ isDarkMode }: { isDarkMode: boolean }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.2 }}
      className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl p-6`}
    >
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className={`text-xl font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'} flex items-center gap-2`}>
            <TrendingUp className="w-5 h-5 text-orange-500" />
            Revenue Overview
          </h2>
          <p className="text-sm text-gray-400 mt-1">Monthly revenue and order trends</p>
        </div>
        <button className={`px-4 py-2 rounded-xl ${isDarkMode ? 'bg-gray-800 hover:bg-gray-700' : 'bg-gray-100 hover:bg-gray-200'} transition-all flex items-center gap-2 border ${isDarkMode ? 'border-gray-700' : 'border-gray-200'}`}>
          <Calendar className="w-4 h-4" />
          <span className="text-sm font-medium">Last 7 months</span>
        </button>
      </div>
      <div className="h-80">
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={data}>
            <defs>
              <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor="#F88F3A" stopOpacity={0.3}/>
                <stop offset="95%" stopColor="#F88F3A" stopOpacity={0}/>
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke={isDarkMode ? '#2a2a2a' : '#e5e5e5'} />
            <XAxis dataKey="name" stroke={isDarkMode ? '#666' : '#999'} />
            <YAxis stroke={isDarkMode ? '#666' : '#999'} />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: isDarkMode ? '#1f1f1f' : '#fff',
                border: `1px solid ${isDarkMode ? '#2a2a2a' : '#e5e5e5'}`,
                borderRadius: '12px',
                padding: '12px'
              }}
            />
            <Area type="monotone" dataKey="revenue" stroke="#F88F3A" strokeWidth={3} fillOpacity={1} fill="url(#colorRevenue)" />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </motion.div>
  );
}

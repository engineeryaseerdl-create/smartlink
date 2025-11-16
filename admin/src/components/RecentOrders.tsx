"use client"

import { motion } from 'framer-motion';
import { Filter, Download, MoreVertical, Eye } from 'lucide-react';

const recentOrders = [
  { id: "ORD-2024-001", customer: "Adebayo Johnson", amount: "₦15,230", status: "delivered", date: "2 hours ago", items: 5 },
  { id: "ORD-2024-002", customer: "Bisi Adekoya", amount: "₦8,750", status: "processing", date: "4 hours ago", items: 3 },
  { id: "ORD-2024-003", customer: "Chukwu Okafor", amount: "₦22,180", status: "out-for-delivery", date: "6 hours ago", items: 7 },
  { id: "ORD-2024-004", customer: "Folake Bello", amount: "₦3,420", status: "pending", date: "8 hours ago", items: 2 },
  { id: "ORD-2024-005", customer: "Ibrahim Musa", amount: "₦12,890", status: "delivered", date: "10 hours ago", items: 4 },
];

const statusConfig = {
  delivered: { bg: 'bg-green-500/20', text: 'text-green-500', label: 'DELIVERED' },
  processing: { bg: 'bg-blue-500/20', text: 'text-blue-500', label: 'PROCESSING' },
  'out-for-delivery': { bg: 'bg-orange-500/20', text: 'text-orange-500', label: 'OUT FOR DELIVERY' },
  pending: { bg: 'bg-gray-500/20', text: 'text-gray-500', label: 'PENDING' },
};

export default function RecentOrders({ isDarkMode }: { isDarkMode: boolean }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.3 }}
      className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl overflow-hidden`}
    >
      <div className="p-6 border-b border-gray-800">
        <div className="flex items-center justify-between">
          <div>
            <h2 className={`text-xl font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>Recent Orders</h2>
            <p className="text-sm text-gray-400 mt-1">Latest transactions from your customers</p>
          </div>
          <div className="flex items-center gap-2">
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className={`px-4 py-2 rounded-xl ${isDarkMode ? 'hover:bg-gray-800 text-gray-400' : 'hover:bg-gray-100 text-gray-600'} transition-all flex items-center gap-2 border ${isDarkMode ? 'border-gray-800' : 'border-gray-200'}`}
            >
              <Filter className="w-4 h-4" />
              <span className="text-sm font-medium">Filter</span>
            </motion.button>
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="px-4 py-2 rounded-xl bg-orange-500 hover:bg-orange-600 text-white transition-all flex items-center gap-2 shadow-lg shadow-orange-500/30"
            >
              <Download className="w-4 h-4" />
              <span className="text-sm font-medium">Export</span>
            </motion.button>
          </div>
        </div>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className={`border-b ${isDarkMode ? 'border-gray-800 bg-gray-800/30' : 'border-gray-200 bg-gray-50'}`}>
              <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase tracking-wider`}>Order ID</th>
              <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase tracking-wider`}>Customer</th>
              <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase tracking-wider`}>Amount</th>
              <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase tracking-wider`}>Status</th>
              <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase tracking-wider`}>Date</th>
              <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase tracking-wider`}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {recentOrders.map((order, index) => (
              <motion.tr
                key={order.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.4 + index * 0.05 }}
                className={`border-b ${isDarkMode ? 'border-gray-800 hover:bg-gray-800/30' : 'border-gray-200 hover:bg-gray-50'} transition-all group`}
              >
                <td className="p-4">
                  <span className={`${isDarkMode ? 'text-white' : 'text-gray-900'} font-semibold text-sm`}>
                    {order.id}
                  </span>
                </td>
                <td className="p-4">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                      <span className="text-white text-xs font-bold">
                        {order.customer.split(' ').map(n => n[0]).join('')}
                      </span>
                    </div>
                    <div>
                      <span className={`${isDarkMode ? 'text-white' : 'text-gray-900'} font-medium block`}>
                        {order.customer}
                      </span>
                      <span className="text-xs text-gray-400">{order.items} items</span>
                    </div>
                  </div>
                </td>
                <td className="p-4">
                  <span className={`${isDarkMode ? 'text-white' : 'text-gray-900'} font-bold`}>
                    {order.amount}
                  </span>
                </td>
                <td className="p-4">
                  <span className={`px-3 py-1.5 rounded-full text-xs font-bold ${statusConfig[order.status as keyof typeof statusConfig].bg} ${statusConfig[order.status as keyof typeof statusConfig].text}`}>
                    {statusConfig[order.status as keyof typeof statusConfig].label}
                  </span>
                </td>
                <td className="p-4">
                  <span className={`${isDarkMode ? 'text-gray-400' : 'text-gray-600'} text-sm`}>
                    {order.date}
                  </span>
                </td>
                <td className="p-4">
                  <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button className="p-2 rounded-lg hover:bg-orange-500/20 text-orange-500 transition-all">
                      <Eye className="w-4 h-4" />
                    </button>
                    <button className="p-2 rounded-lg hover:bg-gray-700 text-gray-400 transition-all">
                      <MoreVertical className="w-4 h-4" />
                    </button>
                  </div>
                </td>
              </motion.tr>
            ))}
          </tbody>
        </table>
      </div>
    </motion.div>
  );
}

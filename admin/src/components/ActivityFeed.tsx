"use client"

import { motion } from 'framer-motion';
import { ShoppingCart, User, Package, CreditCard, Clock } from 'lucide-react';

const activities = [
  { type: 'order', user: 'Adebayo J.', action: 'placed a new order', time: '2 min ago', icon: ShoppingCart, color: 'text-blue-500', bg: 'bg-blue-500/10' },
  { type: 'user', user: 'Bisi A.', action: 'registered as seller', time: '15 min ago', icon: User, color: 'text-green-500', bg: 'bg-green-500/10' },
  { type: 'product', user: 'Chukwu O.', action: 'added new product', time: '1 hour ago', icon: Package, color: 'text-purple-500', bg: 'bg-purple-500/10' },
  { type: 'payment', user: 'Folake B.', action: 'completed payment', time: '2 hours ago', icon: CreditCard, color: 'text-orange-500', bg: 'bg-orange-500/10' },
  { type: 'order', user: 'Ibrahim M.', action: 'order delivered', time: '3 hours ago', icon: ShoppingCart, color: 'text-emerald-500', bg: 'bg-emerald-500/10' },
];

export default function ActivityFeed({ isDarkMode }: { isDarkMode: boolean }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.5 }}
      className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl p-6`}
    >
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className={`text-xl font-bold ${isDarkMode ? 'text-white' : 'text-gray-900'}`}>Activity Feed</h2>
          <p className="text-sm text-gray-400 mt-1">Recent platform activity</p>
        </div>
        <Clock className="w-5 h-5 text-orange-500" />
      </div>
      <div className="space-y-4">
        {activities.map((activity, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.6 + index * 0.1 }}
            className="flex items-start gap-3 group"
          >
            <div className={`w-10 h-10 ${activity.bg} rounded-xl flex items-center justify-center flex-shrink-0 group-hover:scale-110 transition-transform`}>
              <activity.icon className={`w-5 h-5 ${activity.color}`} />
            </div>
            <div className="flex-1 min-w-0">
              <p className={`${isDarkMode ? 'text-white' : 'text-gray-900'} text-sm`}>
                <span className="font-semibold">{activity.user}</span> {activity.action}
              </p>
              <p className="text-xs text-gray-400 mt-1">{activity.time}</p>
            </div>
          </motion.div>
        ))}
      </div>
    </motion.div>
  );
}

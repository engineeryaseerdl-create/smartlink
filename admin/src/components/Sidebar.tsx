"use client"

import { motion, AnimatePresence } from 'framer-motion';
import { BarChart3, ShoppingCart, Users, Package, CreditCard, Truck, Settings, MoreVertical, Zap, TrendingUp } from 'lucide-react';

const sidebarItems = [
  { icon: BarChart3, label: "Dashboard", active: true },
  { icon: ShoppingCart, label: "Orders", notifications: 12 },
  { icon: Users, label: "Customers", notifications: 3 },
  { icon: Package, label: "Products" },
  { icon: Truck, label: "Riders", notifications: 5 },
  { icon: CreditCard, label: "Payments" },
  { icon: TrendingUp, label: "Analytics" },
  { icon: Settings, label: "Settings" },
];

export default function Sidebar({ isOpen, isDarkMode }: { isOpen: boolean; isDarkMode: boolean }) {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.aside
          initial={{ x: -300 }}
          animate={{ x: 0 }}
          exit={{ x: -300 }}
          transition={{ type: "spring", damping: 25 }}
          className={`w-72 ${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border-r flex flex-col fixed lg:sticky top-0 h-screen z-40`}
        >
          <div className="p-6 border-b border-gray-800">
            <div className="flex items-center gap-3">
              <div className="relative">
                <div className="w-12 h-12 bg-gradient-to-br from-orange-400 via-orange-500 to-orange-600 rounded-2xl flex items-center justify-center shadow-lg shadow-orange-500/50">
                  <Zap className="w-7 h-7 text-white" fill="white" />
                </div>
                <div className="absolute -top-1 -right-1 w-3 h-3 bg-green-500 rounded-full border-2 border-gray-900 animate-pulse"></div>
              </div>
              <div>
                <h1 className="font-bold text-xl text-white">SmartLink</h1>
                <p className="text-xs text-gray-400">Admin Portal</p>
              </div>
            </div>
          </div>

          <nav className="flex-1 p-4 overflow-y-auto">
            {sidebarItems.map((item, index) => (
              <motion.button
                key={item.label}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05 }}
                className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl mb-2 transition-all group relative ${
                  item.active
                    ? 'bg-gradient-to-r from-orange-500/20 to-orange-600/20 text-orange-500 border border-orange-500/30 shadow-lg shadow-orange-500/10'
                    : isDarkMode
                    ? 'text-gray-400 hover:text-white hover:bg-gray-800/50'
                    : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                }`}
              >
                {item.active && (
                  <motion.div
                    layoutId="activeTab"
                    className="absolute inset-0 bg-gradient-to-r from-orange-500/10 to-orange-600/10 rounded-xl"
                    transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                  />
                )}
                <item.icon className="w-5 h-5 relative z-10" />
                <span className="flex-1 text-left font-medium relative z-10">{item.label}</span>
                {item.notifications && (
                  <span className="px-2 py-0.5 bg-orange-500 text-white text-xs font-bold rounded-full relative z-10">
                    {item.notifications}
                  </span>
                )}
              </motion.button>
            ))}
          </nav>

          <div className={`p-4 border-t ${isDarkMode ? 'border-gray-800' : 'border-gray-200'}`}>
            <div className="flex items-center gap-3 px-4 py-3 rounded-xl bg-gradient-to-br from-blue-500/10 to-purple-600/10 border border-blue-500/20">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-lg">
                <span className="text-white font-bold text-sm">AD</span>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-white font-medium truncate">Admin User</p>
                <p className="text-xs text-gray-400 truncate">admin@smartlink.ng</p>
              </div>
              <button className="text-gray-400 hover:text-white transition-colors">
                <MoreVertical className="w-4 h-4" />
              </button>
            </div>
          </div>
        </motion.aside>
      )}
    </AnimatePresence>
  );
}

"use client"

import { Search, Bell, Moon, Sun, Menu, ChevronDown } from 'lucide-react';
import { motion } from 'framer-motion';
import { useState } from 'react';

export default function Header({ isDarkMode, setIsDarkMode, isSidebarOpen, setIsSidebarOpen }: any) {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <header className={`${isDarkMode ? 'bg-gray-900/80 border-gray-800' : 'bg-white/80 border-gray-200'} border-b backdrop-blur-xl sticky top-0 z-30`}>
      <div className="px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4 flex-1">
            <button
              onClick={() => setIsSidebarOpen(!isSidebarOpen)}
              className={`p-2.5 rounded-xl ${isDarkMode ? 'hover:bg-gray-800 text-gray-400' : 'hover:bg-gray-100 text-gray-600'} transition-all hover:scale-105`}
            >
              <Menu className="w-5 h-5" />
            </button>
            <div className="relative flex-1 max-w-xl">
              <Search className={`absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 ${isDarkMode ? 'text-gray-400' : 'text-gray-400'}`} />
              <input
                type="text"
                placeholder="Search orders, customers, products..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className={`pl-12 pr-4 py-3 w-full rounded-xl ${isDarkMode ? 'bg-gray-800 text-white border-gray-700 focus:border-orange-500' : 'bg-gray-100 text-gray-900 border-gray-200 focus:border-orange-500'} border focus:outline-none focus:ring-2 focus:ring-orange-500/20 transition-all`}
              />
            </div>
          </div>
          <div className="flex items-center gap-3">
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setIsDarkMode(!isDarkMode)}
              className={`p-2.5 rounded-xl ${isDarkMode ? 'hover:bg-gray-800 text-gray-400 hover:text-orange-500' : 'hover:bg-gray-100 text-gray-600 hover:text-orange-500'} transition-all`}
            >
              {isDarkMode ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
            </motion.button>
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className={`relative p-2.5 rounded-xl ${isDarkMode ? 'hover:bg-gray-800 text-gray-400' : 'hover:bg-gray-100 text-gray-600'} transition-all`}
            >
              <Bell className="w-5 h-5" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-orange-500 rounded-full animate-pulse"></span>
              <span className="absolute top-1 right-1 w-3 h-3 bg-orange-500 rounded-full animate-ping opacity-75"></span>
            </motion.button>
            <div className={`h-8 w-px ${isDarkMode ? 'bg-gray-800' : 'bg-gray-200'}`}></div>
            <button className="flex items-center gap-3 px-3 py-2 rounded-xl hover:bg-gray-800/50 transition-all">
              <div className="w-9 h-9 bg-gradient-to-br from-orange-400 to-orange-600 rounded-full flex items-center justify-center shadow-lg">
                <span className="text-white font-bold text-sm">AD</span>
              </div>
              <ChevronDown className="w-4 h-4 text-gray-400" />
            </button>
          </div>
        </div>
      </div>
    </header>
  );
}

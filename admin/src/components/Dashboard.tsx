"use client"

import { useState } from 'react';
import Sidebar from './Sidebar';
import Header from './Header';
import StatsGrid from './StatsGrid';
import RecentOrders from './RecentOrders';
import RevenueChart from './RevenueChart';
import TopProducts from './TopProducts';
import ActivityFeed from './ActivityFeed';
import { motion } from 'framer-motion';

export default function Dashboard() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const [isDarkMode, setIsDarkMode] = useState(true);

  return (
    <div className={`min-h-screen ${isDarkMode ? 'bg-black' : 'bg-gray-50'} flex`}>
      <Sidebar isOpen={isSidebarOpen} isDarkMode={isDarkMode} />
      <div className="flex-1 flex flex-col min-w-0">
        <Header 
          isDarkMode={isDarkMode} 
          setIsDarkMode={setIsDarkMode}
          isSidebarOpen={isSidebarOpen}
          setIsSidebarOpen={setIsSidebarOpen}
        />
        <main className="flex-1 p-6 overflow-auto">
          <div className="max-w-[1600px] mx-auto space-y-6">
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
              <h1 className="text-3xl font-bold text-white mb-2">Welcome back, Admin 👋</h1>
              <p className={`${isDarkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                Here's what's happening across SmartLink Nigeria today.
              </p>
            </motion.div>
            <StatsGrid isDarkMode={isDarkMode} />
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <div className="lg:col-span-2 space-y-6">
                <RevenueChart isDarkMode={isDarkMode} />
                <RecentOrders isDarkMode={isDarkMode} />
              </div>
              <div className="space-y-6">
                <TopProducts isDarkMode={isDarkMode} />
                <ActivityFeed isDarkMode={isDarkMode} />
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}

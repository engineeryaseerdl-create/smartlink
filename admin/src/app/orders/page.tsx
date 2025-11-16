"use client"

import { useState } from 'react';
import { motion } from 'framer-motion';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import { Filter, Download, Search, Eye, Edit, Trash2, MoreVertical, Package, Truck, CheckCircle, Clock, XCircle } from 'lucide-react';

const orders = [
  { id: "ORD-2024-001", customer: "Adebayo Johnson", email: "adebayo@email.com", amount: "₦15,230", status: "delivered", date: "2024-01-15", items: 5, payment: "paid" },
  { id: "ORD-2024-002", customer: "Bisi Adekoya", email: "bisi@email.com", amount: "₦8,750", status: "processing", date: "2024-01-15", items: 3, payment: "paid" },
  { id: "ORD-2024-003", customer: "Chukwu Okafor", email: "chukwu@email.com", amount: "₦22,180", status: "out-for-delivery", date: "2024-01-14", items: 7, payment: "paid" },
  { id: "ORD-2024-004", customer: "Folake Bello", email: "folake@email.com", amount: "₦3,420", status: "pending", date: "2024-01-14", items: 2, payment: "pending" },
  { id: "ORD-2024-005", customer: "Ibrahim Musa", email: "ibrahim@email.com", amount: "₦12,890", status: "delivered", date: "2024-01-13", items: 4, payment: "paid" },
  { id: "ORD-2024-006", customer: "Grace Eze", email: "grace@email.com", amount: "₦18,500", status: "cancelled", date: "2024-01-13", items: 6, payment: "refunded" },
  { id: "ORD-2024-007", customer: "Yusuf Bello", email: "yusuf@email.com", amount: "₦9,200", status: "processing", date: "2024-01-12", items: 3, payment: "paid" },
  { id: "ORD-2024-008", customer: "Amina Sani", email: "amina@email.com", amount: "₦25,600", status: "delivered", date: "2024-01-12", items: 8, payment: "paid" },
];

const statusConfig = {
  delivered: { icon: CheckCircle, bg: 'bg-green-500/20', text: 'text-green-500', label: 'DELIVERED' },
  processing: { icon: Package, bg: 'bg-blue-500/20', text: 'text-blue-500', label: 'PROCESSING' },
  'out-for-delivery': { icon: Truck, bg: 'bg-orange-500/20', text: 'text-orange-500', label: 'OUT FOR DELIVERY' },
  pending: { icon: Clock, bg: 'bg-yellow-500/20', text: 'text-yellow-500', label: 'PENDING' },
  cancelled: { icon: XCircle, bg: 'bg-red-500/20', text: 'text-red-500', label: 'CANCELLED' },
};

export default function OrdersPage() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('all');

  const filteredOrders = orders.filter(order => {
    const matchesSearch = order.customer.toLowerCase().includes(searchQuery.toLowerCase()) || 
                         order.id.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus = selectedStatus === 'all' || order.status === selectedStatus;
    return matchesSearch && matchesStatus;
  });

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
          <div className="max-w-[1600px] mx-auto">
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
              <h1 className="text-3xl font-bold text-white mb-2">Orders Management</h1>
              <p className={`${isDarkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                Manage and track all customer orders
              </p>
            </motion.div>

            {/* Stats Cards */}
            <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
              {[
                { label: 'Total Orders', value: '12,847', icon: Package, color: 'blue' },
                { label: 'Pending', value: '234', icon: Clock, color: 'yellow' },
                { label: 'Processing', value: '567', icon: Truck, color: 'orange' },
                { label: 'Delivered', value: '11,890', icon: CheckCircle, color: 'green' },
              ].map((stat, index) => (
                <motion.div
                  key={stat.label}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 }}
                  className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl p-6`}
                >
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-gray-400 text-sm mb-1">{stat.label}</p>
                      <p className="text-2xl font-bold text-white">{stat.value}</p>
                    </div>
                    <div className={`w-12 h-12 bg-${stat.color}-500/10 rounded-xl flex items-center justify-center`}>
                      <stat.icon className={`w-6 h-6 text-${stat.color}-500`} />
                    </div>
                  </div>
                </motion.div>
              ))}
            </div>

            {/* Orders Table */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 }}
              className={`${isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-200'} border rounded-2xl overflow-hidden`}
            >
              <div className="p-6 border-b border-gray-800">
                <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                  <div className="relative flex-1 max-w-md">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="text"
                      placeholder="Search orders..."
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      className={`pl-10 pr-4 py-2.5 w-full rounded-xl ${isDarkMode ? 'bg-gray-800 text-white border-gray-700' : 'bg-gray-100 text-gray-900 border-gray-200'} border focus:outline-none focus:ring-2 focus:ring-orange-500/50`}
                    />
                  </div>
                  <div className="flex items-center gap-3">
                    <select
                      value={selectedStatus}
                      onChange={(e) => setSelectedStatus(e.target.value)}
                      className={`px-4 py-2.5 rounded-xl ${isDarkMode ? 'bg-gray-800 text-white border-gray-700' : 'bg-gray-100 text-gray-900 border-gray-200'} border focus:outline-none focus:ring-2 focus:ring-orange-500/50`}
                    >
                      <option value="all">All Status</option>
                      <option value="pending">Pending</option>
                      <option value="processing">Processing</option>
                      <option value="out-for-delivery">Out for Delivery</option>
                      <option value="delivered">Delivered</option>
                      <option value="cancelled">Cancelled</option>
                    </select>
                    <button className={`px-4 py-2.5 rounded-xl ${isDarkMode ? 'hover:bg-gray-800 text-gray-400' : 'hover:bg-gray-100 text-gray-600'} transition-all flex items-center gap-2 border ${isDarkMode ? 'border-gray-800' : 'border-gray-200'}`}>
                      <Filter className="w-4 h-4" />
                      <span>Filter</span>
                    </button>
                    <button className="px-4 py-2.5 rounded-xl bg-orange-500 hover:bg-orange-600 text-white transition-all flex items-center gap-2 shadow-lg shadow-orange-500/30">
                      <Download className="w-4 h-4" />
                      <span>Export</span>
                    </button>
                  </div>
                </div>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className={`border-b ${isDarkMode ? 'border-gray-800 bg-gray-800/30' : 'border-gray-200 bg-gray-50'}`}>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Order ID</th>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Customer</th>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Amount</th>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Status</th>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Payment</th>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Date</th>
                      <th className={`text-left p-4 ${isDarkMode ? 'text-gray-400' : 'text-gray-600'} font-semibold text-xs uppercase`}>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredOrders.map((order, index) => {
                      const StatusIcon = statusConfig[order.status as keyof typeof statusConfig].icon;
                      return (
                        <motion.tr
                          key={order.id}
                          initial={{ opacity: 0, x: -20 }}
                          animate={{ opacity: 1, x: 0 }}
                          transition={{ delay: index * 0.05 }}
                          className={`border-b ${isDarkMode ? 'border-gray-800 hover:bg-gray-800/30' : 'border-gray-200 hover:bg-gray-50'} transition-all group`}
                        >
                          <td className="p-4">
                            <span className="text-white font-semibold">{order.id}</span>
                          </td>
                          <td className="p-4">
                            <div className="flex items-center gap-3">
                              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                                <span className="text-white text-xs font-bold">
                                  {order.customer.split(' ').map(n => n[0]).join('')}
                                </span>
                              </div>
                              <div>
                                <p className="text-white font-medium">{order.customer}</p>
                                <p className="text-xs text-gray-400">{order.email}</p>
                              </div>
                            </div>
                          </td>
                          <td className="p-4">
                            <span className="text-white font-bold">{order.amount}</span>
                          </td>
                          <td className="p-4">
                            <span className={`px-3 py-1.5 rounded-full text-xs font-bold flex items-center gap-1.5 w-fit ${statusConfig[order.status as keyof typeof statusConfig].bg} ${statusConfig[order.status as keyof typeof statusConfig].text}`}>
                              <StatusIcon className="w-3.5 h-3.5" />
                              {statusConfig[order.status as keyof typeof statusConfig].label}
                            </span>
                          </td>
                          <td className="p-4">
                            <span className={`px-2 py-1 rounded-full text-xs font-medium ${order.payment === 'paid' ? 'bg-green-500/20 text-green-500' : order.payment === 'pending' ? 'bg-yellow-500/20 text-yellow-500' : 'bg-gray-500/20 text-gray-500'}`}>
                              {order.payment.toUpperCase()}
                            </span>
                          </td>
                          <td className="p-4">
                            <span className="text-gray-400 text-sm">{order.date}</span>
                          </td>
                          <td className="p-4">
                            <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                              <button className="p-2 rounded-lg hover:bg-blue-500/20 text-blue-500 transition-all">
                                <Eye className="w-4 h-4" />
                              </button>
                              <button className="p-2 rounded-lg hover:bg-orange-500/20 text-orange-500 transition-all">
                                <Edit className="w-4 h-4" />
                              </button>
                              <button className="p-2 rounded-lg hover:bg-red-500/20 text-red-500 transition-all">
                                <Trash2 className="w-4 h-4" />
                              </button>
                            </div>
                          </td>
                        </motion.tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </motion.div>
          </div>
        </main>
      </div>
    </div>
  );
}

const mongoose = require('mongoose');
const Product = require('./models/Product');
const User = require('./models/User');
require('dotenv').config();

const sampleProducts = [
  {
    name: 'Fresh Tomatoes (1kg)',
    description: 'Farm fresh tomatoes from local farms',
    price: 800,
    category: 'food',
    images: ['https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg'],
    stock: 50,
    rating: { average: 4.5, count: 23 }
  },
  {
    name: 'Samsung Galaxy A54',
    description: 'Brand new Samsung Galaxy A54 with 128GB storage',
    price: 285000,
    category: 'electronics',
    images: [
      'https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg',
      'https://images.pexels.com/photos/1591056/pexels-photo-1591056.jpeg'
    ],
    stock: 15,
    rating: { average: 4.8, count: 45 }
  },
  {
    name: 'LG 32-inch Smart TV',
    description: 'LG Smart TV with WiFi and Netflix support',
    price: 125000,
    category: 'electronics',
    images: ['https://images.pexels.com/photos/1201996/pexels-photo-1201996.jpeg'],
    stock: 8,
    rating: { average: 4.6, count: 34 }
  },
  {
    name: 'Men\'s Sneakers',
    description: 'Quality imported sneakers, various sizes available',
    price: 15000,
    category: 'fashion',
    images: ['https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg'],
    stock: 40,
    rating: { average: 4.3, count: 56 }
  }
];

async function seedDatabase() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Find a seller user or create one
    let seller = await User.findOne({ role: 'seller' });
    if (!seller) {
      seller = await User.create({
        name: 'Test Seller',
        email: 'seller@test.com',
        password: 'password123',
        phone: '08012345678',
        role: 'seller',
        location: 'Lagos, Nigeria',
        businessName: 'Test Store',
        avatar: 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'
      });
    }

    // Clear existing products
    await Product.deleteMany({});

    // Add seller ID to products and create them
    const productsWithSeller = sampleProducts.map(product => ({
      ...product,
      seller: seller._id
    }));

    await Product.insertMany(productsWithSeller);
    console.log('Sample products added successfully');
    
    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
}

seedDatabase();
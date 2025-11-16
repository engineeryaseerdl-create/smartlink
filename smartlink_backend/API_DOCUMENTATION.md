# SmartLink API Documentation

## Base URL
```
http://localhost:5000/api
```

## Authentication
All protected routes require Bearer token in Authorization header:
```
Authorization: Bearer YOUR_JWT_TOKEN
```

## Endpoints

### 🔐 Authentication
- `POST /auth/register` - Register user
- `POST /auth/login` - Login user
- `GET /auth/me` - Get current user

### 👤 Users
- `PUT /users/profile` - Update profile
- `GET /users/:id` - Get user by ID

### 📦 Products
- `GET /products` - Get all products
- `GET /products/:id` - Get single product
- `POST /products` - Create product (sellers)
- `PUT /products/:id` - Update product (sellers)
- `DELETE /products/:id` - Delete product (sellers)
- `GET /products/seller/my-products` - Get seller's products

### 🛒 Orders
- `POST /orders` - Create order (buyers)
- `GET /orders` - Get orders (role-based)
- `GET /orders/:id` - Get single order
- `PUT /orders/:id/status` - Update order status
- `PUT /orders/:id/assign-rider` - Assign rider (sellers)

### 🏍️ Riders
- `GET /riders/available` - Get available riders
- `PUT /riders/availability` - Update availability
- `GET /riders/deliveries` - Get rider deliveries
- `GET /riders/earnings` - Get rider earnings

### ⭐ Reviews
- `POST /reviews` - Create review (buyers)
- `GET /reviews/product/:productId` - Get product reviews
- `POST /reviews/:reviewId/helpful` - Vote helpful

### 🔔 Notifications
- `GET /notifications` - Get user notifications
- `PUT /notifications/read` - Mark as read
- `PUT /notifications/read-all` - Mark all as read

### 💬 Chat
- `POST /chat` - Create/get chat
- `GET /chat` - Get user chats
- `GET /chat/:chatId/messages` - Get messages
- `POST /chat/:chatId/messages` - Send message
- `PUT /chat/:chatId/read` - Mark as read

### 📊 Analytics
- `GET /analytics/seller` - Seller analytics
- `GET /analytics/rider` - Rider analytics
- `GET /analytics/admin` - Admin analytics

### 📤 Upload
- `POST /upload/single` - Upload single image
- `POST /upload/multiple` - Upload multiple images

### 🔍 Search
- `GET /search/products` - Advanced product search
- `GET /search/sellers` - Search sellers
- `GET /search/suggestions` - Get search suggestions

### 👨‍💼 Admin (Admin only)
- `GET /admin/users` - Get all users
- `PUT /admin/users/:id/toggle-status` - Toggle user status
- `GET /admin/products` - Get all products
- `PUT /admin/products/:id/toggle-status` - Toggle product status
- `GET /admin/orders` - Get all orders
- `GET /admin/reviews` - Get reviews for moderation
- `PUT /admin/reviews/:id/moderate` - Moderate review

## Real-time Events (Socket.io)

### Client Events
- `updateLocation` - Rider location update
- `orderStatusUpdate` - Order status change
- `newOrder` - New order notification
- `sendMessage` - Send chat message

### Server Events
- `newNotification` - New notification received
- `orderUpdate` - Order status updated
- `riderLocationUpdate` - Rider location changed
- `newOrderAvailable` - New order for riders
- `newMessage` - New chat message

## Error Responses
```json
{
  "success": false,
  "message": "Error description",
  "errors": [] // Validation errors if any
}
```

## Success Responses
```json
{
  "success": true,
  "data": {}, // Response data
  "pagination": {} // For paginated responses
}
```
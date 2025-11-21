# Rating & Review System Integration

## ✅ Backend Changes

### New Models Created
1. **Rating.js** - For seller and rider ratings
   - Fields: order, reviewer, reviewee, revieweeType, rating (1-5), comment
   - Prevents duplicate ratings per order

2. **Dispute.js** - For order complaints
   - Fields: order, reporter, disputeType, description, status, resolution
   - Types: delayed, failed, damaged, wrong_item, other
   - Status: pending, resolved, rejected

### New Controllers
1. **ratingController.js**
   - `submitRating()` - Submit rating for seller/rider
   - `getUserRatings()` - Get all ratings for a user
   - `submitDispute()` - Submit order dispute
   - Auto-updates user rating average

### New Routes
1. **routes/ratings.js**
   - POST `/api/ratings` - Submit rating (buyer only)
   - GET `/api/ratings/:userId` - Get user ratings

2. **routes/disputes.js**
   - POST `/api/disputes` - Submit dispute (buyer only)

### Updated Files
1. **server.js** - Added rating and dispute routes
2. **routes/upload.js** - Fixed to return full image URLs
3. **controllers/productController.js** - Transform relative image paths to full URLs

## ✅ Frontend Changes

### New Models
1. **rating_model.dart**
   - RatingModel - For ratings data
   - DisputeModel - For disputes data

### New Screens
1. **rate_order_screen.dart**
   - Rate sellers and riders (1-5 stars)
   - Optional comment field
   - Clean star rating UI

2. **dispute_order_screen.dart**
   - Report order issues
   - Multiple dispute types
   - Detailed description field

### New Services
1. **rating_service.dart**
   - API integration for ratings
   - API integration for disputes
   - Token-based authentication

### Updated Files
1. **order_model.dart**
   - Updated OrderStatus enum with all 7 statuses:
     - pending, confirmed, assigned, pickedUp, inTransit, delivered, completed, refunded, cancelled

2. **order_tracking_screen.dart**
   - Added "Rate Order" and "Report Issue" buttons
   - Only visible to buyers on delivered orders
   - Updated status colors and text

## 🎯 Features Implemented

### Ratings & Reviews
- ⭐ 1-5 star rating system
- 💬 Optional comments
- 👤 Rate both sellers and riders
- 🔒 Only buyers can rate
- ✅ Only delivered orders can be rated
- 🚫 Prevents duplicate ratings

### Disputes
- 🚨 Report delivery issues
- 📝 5 dispute types
- 📄 Detailed descriptions
- 🔄 Status tracking (pending/resolved/rejected)

### Order Tracking
- 📦 7 order statuses
- 🎨 Color-coded status badges
- 📱 Responsive design
- 🔔 Action buttons for delivered orders

## 🔧 API Endpoints

### Ratings
```
POST /api/ratings
Body: {
  orderId, revieweeId, revieweeType, rating, comment
}

GET /api/ratings/:userId
Returns: { ratings, average, count }
```

### Disputes
```
POST /api/disputes
Body: {
  orderId, disputeType, description
}
```

## 🐛 Bug Fixes

### Product Images Not Displaying
**Problem:** Images stored as relative paths (`/uploads/file.jpg`)

**Solution:**
1. Updated upload route to return full URLs
2. Added URL transformation in product controllers
3. Images now return as `http://localhost:5000/uploads/file.jpg`

## 🚀 Testing

### Test Rating Feature
1. Login as buyer
2. Go to delivered order
3. Click "Rate Order"
4. Rate seller and rider
5. Submit

### Test Dispute Feature
1. Login as buyer
2. Go to any order
3. Click "Report Issue"
4. Select issue type
5. Add description
6. Submit

## 📝 Notes

- Ratings affect user visibility (backend calculates average)
- Disputes are tracked for admin review
- All endpoints require authentication
- Only buyers can submit ratings/disputes
- Images now display with full server URLs

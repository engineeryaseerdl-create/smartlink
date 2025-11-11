# SmartLink - Quick Start Guide

## 🚀 Running the App

### Option 1: Using Flutter CLI (Recommended)

```bash
# Navigate to project directory
cd smartlink

# Get dependencies
flutter pub get

# Check for connected devices
flutter devices

# Run the app
flutter run
```

### Option 2: Using VS Code
1. Open the project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select your target device
4. Wait for the app to build and launch

### Option 3: Using Android Studio
1. Open Android Studio
2. Click "Open an Existing Project"
3. Navigate to the smartlink folder
4. Click the "Run" button (▶️)

## 🧪 Testing Demo Accounts

### Login Credentials

| Role | Email | Password | Access |
|------|-------|----------|--------|
| **Buyer** | buyer@test.com | any | Browse & order products |
| **Seller** | seller@test.com | any | Manage products & orders |
| **Rider** | rider@test.com | any | View & complete deliveries |

**Note:** Password validation is bypassed in mock mode - any password works!

## 📱 App Navigation Guide

### As a Buyer
1. **Login** with buyer@test.com
2. **Browse** products on the home screen
3. **Search** or filter by category
4. **Tap a product** to view details
5. **Buy Now** to place an order
6. **View Orders** tab to track your purchases
7. **Profile** to view your account

### As a Seller
1. **Login** with seller@test.com
2. **Dashboard** shows your sales stats
3. **Products** tab - view your listings
4. **Tap +** button to add a new product
5. **Orders** tab - view customer orders
6. **Tap an order** to assign a rider
7. **Profile** to view your account

### As a Rider
1. **Login** with rider@test.com
2. **Deliveries** shows assigned orders
3. **Start Delivery** when ready to pick up
4. **Mark as Delivered** when complete
5. **Earnings** tab shows your income
6. **Profile** to view your account

## 🎨 UI Features to Explore

### Animations
- **Splash screen** - Animated logo on app launch
- **Onboarding** - Smooth page transitions
- **Product cards** - Hover and tap effects
- **Bottom sheet** - Order confirmation modal

### Navigation
- **Bottom Nav Bar** - Role-specific tabs
- **Back Navigation** - System back button support
- **Deep Linking** - Direct screen access (ready for implementation)

### Interactions
- **Pull to refresh** - Update product lists
- **Search** - Real-time filtering
- **Category chips** - Toggle filter on/off
- **Order status badges** - Color-coded states
- **Rating stars** - Visual feedback

## 🧩 Key Screens

### 1. Splash & Onboarding
```
SplashScreen → OnboardingScreen (3 slides) → LoginScreen
```

### 2. Authentication
```
LoginScreen ↔ RegisterScreen (with role selection)
```

### 3. Buyer Flow
```
BuyerHomeScreen
  ├─ Home (Products grid)
  ├─ Categories (Category browser)
  ├─ Orders (Order history)
  └─ Profile

ProductDetailScreen → Order Confirmation Modal
OrderDetailScreen → View order status
```

### 4. Seller Flow
```
SellerHomeScreen
  ├─ Dashboard (Stats overview)
  ├─ Products (My listings)
  ├─ Orders (Customer orders)
  └─ Profile

AddProductScreen → Add new products
Assign Rider Modal → Select rider for delivery
```

### 5. Rider Flow
```
RiderHomeScreen
  ├─ Deliveries (Active orders)
  ├─ Earnings (Income tracker)
  └─ Profile

Delivery Actions:
  • Start Delivery
  • Mark as Delivered
```

## 🛠️ Development Tips

### Hot Reload
- **Save file** to hot reload (⚡)
- **Ctrl/Cmd + S** in VS Code
- Changes appear instantly without restart

### Debugging
```bash
# Run in debug mode
flutter run --debug

# Run in release mode (faster)
flutter run --release

# Run with specific device
flutter run -d <device-id>
```

### Common Commands
```bash
# Clean build
flutter clean && flutter pub get

# Check for issues
flutter doctor

# Analyze code
flutter analyze

# Format code
flutter format .
```

## 📊 Mock Data Details

### Products (8 items)
- Fresh Tomatoes - ₦800
- Samsung Galaxy A54 - ₦285,000
- Rice 50kg - ₦52,000
- LG Smart TV - ₦125,000
- Toyota Corolla 2015 - ₦4,500,000
- Hisense Refrigerator - ₦245,000
- Men's Sneakers - ₦15,000
- Garri 10kg - ₦5,500

### Riders (5 available)
- Emeka (Okada) - Ikeja
- Chioma (Okada) - Yaba
- Abubakar (Car) - Victoria Island
- Blessing (Okada) - Surulere
- Tunde (Car) - Lekki

### Orders (3 sample orders)
- Pending order - Waiting for rider
- In Transit - Being delivered
- Confirmed - Ready for pickup

## 🔧 Troubleshooting

### Issue: App won't build
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Dependencies error
```bash
rm pubspec.lock
flutter pub get
```

### Issue: Gradle build failed
```bash
cd android
./gradlew clean
cd ..
flutter run
```

### Issue: iOS build failed
```bash
cd ios
pod install
cd ..
flutter run
```

## 📸 Testing Scenarios

### Scenario 1: Complete Buyer Journey
1. Login as buyer
2. Browse products
3. Search for "rice"
4. View product details
5. Place order
6. Check order status in Orders tab

### Scenario 2: Seller Workflow
1. Login as seller
2. View dashboard stats
3. Go to Products tab
4. Add a new product
5. Go to Orders tab
6. Assign a rider to pending order

### Scenario 3: Rider Delivery
1. Login as rider
2. View assigned deliveries
3. Tap "Start Delivery"
4. Tap "Mark as Delivered"
5. Check earnings updated

## 🎯 Expected Behavior

### ✅ What Works (Mock Data)
- User authentication (any password)
- Product browsing and filtering
- Order creation
- Rider assignment
- Order status updates
- Role-based dashboards
- Profile viewing
- Local state persistence

### 🔄 What Needs Backend
- Real authentication
- Actual payment processing
- Live order tracking
- Push notifications
- Real-time chat
- Image uploads
- Google Maps integration

## 📱 Supported Platforms

- ✅ **Android** (5.0+)
- ✅ **iOS** (11.0+)
- 🔄 **Web** (requires flutter web setup)
- 🔄 **Desktop** (requires platform-specific setup)

## 🎓 Learning the Codebase

### Start Here
1. `lib/main.dart` - App entry point
2. `lib/models/` - Data structures
3. `lib/providers/` - State management
4. `lib/views/` - UI screens
5. `assets/mock_data/` - Sample data

### Key Files to Understand
- **Authentication**: `lib/services/auth_service.dart`
- **Data Loading**: `lib/services/mock_data_service.dart`
- **State**: `lib/providers/*_provider.dart`
- **Routing**: `lib/views/shared/home_wrapper.dart`

## 💡 Customization Tips

### Change Colors
Edit `lib/utils/constants.dart`:
```dart
static const Color primaryGreen = Color(0xFF00A86B);
```

### Add New Category
Edit `lib/models/product_model.dart`:
```dart
enum ProductCategory {
  groceries,
  electronics,
  // Add your category here
}
```

### Modify Mock Data
Edit JSON files in `assets/mock_data/`:
- `products.json`
- `riders.json`
- `users.json`
- `orders.json`

## 🚨 Important Notes

1. **Mock Mode**: The app uses mock data - no real backend required
2. **Passwords**: Any password works in demo mode
3. **Images**: Uses Pexels stock photos (internet required)
4. **Location**: Mock locations (Nigerian cities)
5. **Currency**: All prices in Nigerian Naira (₦)

## 📞 Need Help?

Check these files:
- `README.md` - Detailed documentation
- `PROJECT_OVERVIEW.md` - Architecture & features
- Code comments - Inline documentation

---

**Happy Testing! 🎉**

*The app is fully functional with mock data. When you're ready, connect it to a real backend for production use.*

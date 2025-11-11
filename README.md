# SmartLink - Nigerian Multi-Marketplace & Delivery App

**Tagline:** Linking Buyers, Sellers & Riders Across Nigeria

## Overview

SmartLink is a comprehensive Flutter mobile application that connects buyers, sellers, and transporters (Okadas & Cars) across Nigeria. The app facilitates e-commerce transactions and local/interstate delivery services.

## Features

### 🛒 For Buyers
- Browse products from various categories (Groceries, Electronics, Cars, Phones, etc.)
- Search and filter products
- Place orders with real-time tracking
- View order history and status
- Rate sellers and riders

### 🏪 For Sellers
- List and manage products
- Track and manage customer orders
- Assign nearby riders for deliveries
- View sales dashboard and analytics
- Upload product images and descriptions

### 🏍️ For Riders (Okada & Car)
- View assigned deliveries
- Accept and manage delivery requests
- Track earnings
- Update delivery status
- View delivery history

## Project Structure

```
lib/
├── models/           # Data models (User, Product, Order, Rider)
├── providers/        # State management with Provider
├── services/         # Business logic and API services
├── views/            # UI screens
│   ├── auth/        # Login & Registration
│   ├── buyer/       # Buyer screens
│   ├── seller/      # Seller screens
│   ├── rider/       # Rider screens
│   └── shared/      # Shared screens (Profile, Splash)
├── widgets/          # Reusable UI components
└── utils/            # Constants, helpers, themes

assets/
├── images/          # App images and logos
└── mock_data/       # JSON mock data for demo
```

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **UI Design:** Material 3
- **Data Storage:** SharedPreferences (local session)
- **Mock Data:** JSON files
- **Future Backend:** Supabase-ready

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS Emulator or Physical Device

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd smartlink
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Demo Accounts

For testing purposes, use these credentials:

| Role   | Email             | Password    |
|--------|-------------------|-------------|
| Buyer  | buyer@test.com    | any password|
| Seller | seller@test.com   | any password|
| Rider  | rider@test.com    | any password|

## App Flow

### 1. Onboarding
- Splash screen with animated logo
- Three onboarding slides explaining features
- Skip or navigate through slides

### 2. Authentication
- Login with email/password
- Register as Buyer, Seller, or Rider
- Role-based dashboard redirection

### 3. Role-Based Dashboards

#### Buyer Dashboard
- Home: Product listings with categories
- Categories: Browse by category
- Orders: View order history and status
- Profile: Account settings

#### Seller Dashboard
- Dashboard: Sales overview and stats
- Products: Manage product listings
- Orders: View and assign riders to orders
- Profile: Account settings

#### Rider Dashboard
- Deliveries: Active and completed deliveries
- Earnings: Track income and completed rides
- Profile: Account settings

## Mock Data

The app uses mock data stored in JSON files:
- `assets/mock_data/products.json` - Product listings
- `assets/mock_data/riders.json` - Rider information
- `assets/mock_data/users.json` - User accounts
- `assets/mock_data/orders.json` - Order data

## Future Backend Integration

The app is structured for easy API integration:

1. Replace mock data services with HTTP/Dio calls
2. Update `lib/services/auth_service.dart` with real authentication
3. Connect to Supabase for database operations
4. Implement real-time order tracking with WebSockets
5. Add payment gateway integration (Paystack/Flutterwave)

### API Endpoints (Planned)
```
POST /api/auth/login
POST /api/auth/register
GET  /api/products
POST /api/products
GET  /api/orders
POST /api/orders
PUT  /api/orders/:id/assign-rider
GET  /api/riders/nearby
```

## Design System

### Colors
- Primary Green: `#00A86B`
- Gold: `#FFD700`
- White: `#FFFFFF`
- Grey: Various shades

### Typography
- Font: Inter (Google Fonts)
- Headings: Bold, 24-28px
- Body: Regular, 14-16px
- Small: 12px

### Spacing
- XS: 4px
- SM: 8px
- MD: 16px
- LG: 24px
- XL: 32px
- XXL: 48px

## Key Features Implementation

### State Management
Uses Provider for reactive state management across:
- Authentication state
- Product listings
- Order management
- Rider availability

### Navigation
- Bottom Navigation Bar (role-specific)
- Stack-based navigation with MaterialPageRoute
- Hero transitions for smooth animations

### Data Flow
```
User Action → Provider → Service → Mock Data → UI Update
```

## Screenshots

*(Add screenshots here when available)*

## Contributing

This is a demo project. For production use:
1. Replace mock data with real backend
2. Add proper error handling
3. Implement authentication tokens
4. Add payment integration
5. Enable push notifications
6. Implement real-time tracking

## License

MIT License - See LICENSE file for details

## Support

For questions or issues, contact: support@smartlink.ng

---

**Built with ❤️ for Nigerian market**

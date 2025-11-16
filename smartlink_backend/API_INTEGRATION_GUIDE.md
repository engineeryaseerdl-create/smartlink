# SmartLink Rider Cluster API Integration Guide

## Overview
This guide explains how to integrate the Rider Cluster System with your SmartLink backend API.

## Backend Setup

### 1. Install Dependencies
```bash
cd smartlink_backend
npm install
```

### 2. Start Server
```bash
npm run dev
```

## API Endpoints

### Cluster Management

#### Get All Clusters
```http
GET /api/clusters
Query Parameters:
  - location: string (optional) - Filter by location
  - serviceArea: string (optional) - Filter by service area
  - isOnline: boolean (optional) - Filter by online status
  - page: number (default: 1)
  - limit: number (default: 20)

Response:
{
  "success": true,
  "clusters": [...],
  "pagination": {
    "page": 1,
    "pages": 5,
    "total": 100
  }
}
```

#### Get Single Cluster
```http
GET /api/clusters/:id

Response:
{
  "success": true,
  "cluster": {
    "_id": "...",
    "name": "Kano Central Riders",
    "location": {...},
    "leader": {...},
    "members": [...],
    "rating": {...},
    "totalDeliveries": 245
  }
}
```

#### Create Cluster (Riders Only)
```http
POST /api/clusters
Headers:
  Authorization: Bearer <rider_token>

Body:
{
  "name": "Kano Central Riders",
  "location": {
    "address": "Sabon Gari, Kano",
    "coordinates": {
      "latitude": 12.0022,
      "longitude": 8.5919
    }
  },
  "serviceAreas": ["Sabon Gari", "Fagge", "Nassarawa"],
  "vehicleTypes": ["motorcycle", "bicycle"],
  "operatingHours": "6AM - 10PM",
  "backupContactId": "rider_id" (optional)
}

Response:
{
  "success": true,
  "cluster": {...}
}
```

#### Update Cluster (Leader Only)
```http
PUT /api/clusters/:id
Headers:
  Authorization: Bearer <leader_token>

Body:
{
  "name": "Updated Name",
  "isOnline": true,
  "serviceAreas": ["Area1", "Area2"]
}
```

#### Add Member to Cluster (Leader Only)
```http
POST /api/clusters/:id/members
Headers:
  Authorization: Bearer <leader_token>

Body:
{
  "riderId": "rider_user_id"
}
```

#### Remove Member (Leader Only)
```http
DELETE /api/clusters/:id/members
Headers:
  Authorization: Bearer <leader_token>

Body:
{
  "riderId": "rider_user_id"
}
```

#### Assign Order to Cluster (Sellers Only)
```http
POST /api/clusters/:id/assign-order
Headers:
  Authorization: Bearer <seller_token>

Body:
{
  "orderId": "order_id",
  "specificRiderId": "rider_id" (optional)
}

Response:
{
  "success": true,
  "order": {...},
  "cluster": {...}
}
```

#### Get Cluster Stats
```http
GET /api/clusters/:id/stats
Headers:
  Authorization: Bearer <token>

Response:
{
  "success": true,
  "stats": {
    "totalMembers": 12,
    "activeMembers": 10,
    "totalDeliveries": 245,
    "completedDeliveries": 230,
    "totalEarnings": 125000,
    "averageRating": 4.8,
    "ratingCount": 156
  }
}
```

## Flutter Integration

### 1. Update API Service Base URL
```dart
// lib/services/api_service.dart
class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  // or your production URL
}
```

### 2. Use Cluster Provider
```dart
// Load clusters
await context.read<ClusterProvider>().loadClusters(
  location: 'Kano',
  isOnline: true,
);

// Create cluster
final cluster = await context.read<ClusterProvider>().createCluster(
  name: 'My Cluster',
  location: {'address': 'Kano'},
  serviceAreas: ['Area1', 'Area2'],
);

// Assign order to cluster
final success = await context.read<ClusterProvider>().assignOrderToCluster(
  clusterId,
  orderId,
);
```

### 3. Display Clusters
```dart
// Use ClusterSelector widget
ClusterSelector(
  order: myOrder,
  onClusterSelected: (cluster) {
    // Handle cluster selection
  },
)
```

## Testing

### 1. Register Test Users
```bash
# Register a rider
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Rider",
    "email": "rider@test.com",
    "password": "123456",
    "phone": "08012345678",
    "role": "rider",
    "vehicleType": "motorcycle"
  }'
```

### 2. Create Test Cluster
```bash
# Login and get token first
curl -X POST http://localhost:5000/api/clusters \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <rider_token>" \
  -d '{
    "name": "Test Cluster",
    "location": {"address": "Test Location"},
    "serviceAreas": ["Area1", "Area2"],
    "vehicleTypes": ["motorcycle"]
  }'
```

### 3. Test in Flutter
```dart
// In your Flutter app
final clusterProvider = Provider.of<ClusterProvider>(context, listen: false);
await clusterProvider.loadClusters();

// Check if clusters loaded
print('Clusters: ${clusterProvider.clusters.length}');
```

## Error Handling

### Common Errors
- **401 Unauthorized**: Token missing or invalid
- **403 Forbidden**: User doesn't have permission
- **404 Not Found**: Cluster or resource not found
- **400 Bad Request**: Invalid data in request

### Flutter Error Handling
```dart
try {
  await clusterProvider.loadClusters();
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

## Production Checklist

- [ ] Update API base URL to production server
- [ ] Add proper error handling
- [ ] Implement retry logic for failed requests
- [ ] Add loading states
- [ ] Test all cluster operations
- [ ] Verify authentication flow
- [ ] Test order assignment
- [ ] Validate cluster creation
- [ ] Test member management

## Support

For issues or questions:
- Backend API: Check `smartlink_backend/API_DOCUMENTATION.md`
- Cluster System: Check `RIDER_CLUSTER_SYSTEM.md`
- General: Contact development team
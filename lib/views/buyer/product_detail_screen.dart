import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/product_card.dart';
import 'payment_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showOrderConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _OrderConfirmationSheet(product: widget.product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageCarousel(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    Helpers.formatCurrency(widget.product.price),
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Seller Information',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primaryGreen,
                        child: Icon(Icons.store, color: AppColors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.sellerName,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: AppColors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.product.sellerLocation,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Description',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.product.description,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Icon(Icons.inventory, color: AppColors.grey),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Stock: ${widget.product.stockQuantity} available',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSimilarItems(),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Add to Cart',
                  onPressed: () {
                    context.read<CartProvider>().addToCart(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart!'),
                        backgroundColor: AppColors.successGreen,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  isOutlined: true,
                  backgroundColor: AppColors.primaryGreen,
                  icon: Icons.add_shopping_cart,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CustomButton(
                  text: 'Buy Now',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          product: widget.product,
                          quantity: 1,
                        ),
                      ),
                    );
                  },
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: widget.product.images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showImageGallery(context, index),
              child: Image.network(
                widget.product.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.lightGrey,
                    child: const Icon(Icons.image, size: 100),
                  );
                },
              ),
            );
          },
        ),
        // Image indicators
        if (widget.product.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        // Image counter
        if (widget.product.images.length > 1)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${widget.product.images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showImageGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ImageGalleryScreen(
          images: widget.product.images,
          initialIndex: initialIndex,
          productTitle: widget.product.title,
        ),
      ),
    );
  }

  Widget _buildSimilarItems() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final similarProducts = productProvider.getSimilarProducts(widget.product);
        
        if (similarProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Similar Items',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarProducts.length,
                itemBuilder: (context, index) {
                  final product = similarProducts[index];
                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(
                      right: index < similarProducts.length - 1 ? AppSpacing.md : 0,
                    ),
                    child: ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ImageGalleryScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String productTitle;

  const _ImageGalleryScreen({
    required this.images,
    required this.initialIndex,
    required this.productTitle,
  });

  @override
  State<_ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<_ImageGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.productTitle,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1}/${widget.images.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: false,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 3,
            child: Center(
              child: Image.network(
                widget.images[index],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.lightGrey,
                    child: const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderConfirmationSheet extends StatefulWidget {
  final ProductModel product;

  const _OrderConfirmationSheet({required this.product});

  @override
  State<_OrderConfirmationSheet> createState() =>
      _OrderConfirmationSheetState();
}

class _OrderConfirmationSheetState extends State<_OrderConfirmationSheet> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;
    final total = widget.product.price * _quantity;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Confirm Order',
                style: AppTextStyles.heading2,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                child: Image.network(
                  widget.product.images.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppColors.lightGrey,
                      child: const Icon(Icons.image),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      Helpers.formatCurrency(widget.product.price),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity:', style: AppTextStyles.bodyLarge),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$_quantity',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _quantity < widget.product.stockQuantity
                        ? () => setState(() => _quantity++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: AppTextStyles.heading3),
              Text(
                Helpers.formatCurrency(total),
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton(
            text: 'Place Order',
            onPressed: () {
              final order = OrderModel(
                id: 'order_${DateTime.now().millisecondsSinceEpoch}',
                buyerId: user.id,
                buyerName: user.name,
                buyerPhone: user.phone ?? '',
                buyerLocation: user.location ?? '',
                sellerId: widget.product.sellerId,
                sellerName: widget.product.sellerName,
                sellerLocation: widget.product.sellerLocation,
                items: [
                  OrderItem(
                    productId: widget.product.id,
                    productTitle: widget.product.title,
                    productImage: widget.product.images.first,
                    quantity: _quantity,
                    price: widget.product.price,
                  ),
                ],
                totalAmount: total,
                status: OrderStatus.pending,
                createdAt: DateTime.now(),
              );

              context.read<OrderProvider>().createOrder(
                items: [{
                  'product': widget.product.id,
                  'quantity': _quantity,
                }],
                deliveryAddress: {
                  'street': user.location ?? 'Lagos',
                  'city': 'Lagos',
                  'state': 'Lagos',
                },
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

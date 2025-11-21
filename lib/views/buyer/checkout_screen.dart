import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_modal.dart';
import '../../models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _paymentMethod = 'card';
  bool _isProcessing = false;
  bool _isExpressDelivery = false;
  DateTime? _selectedDeliveryDate;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildProgressStep(int stepNumber, String title, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.primaryGreen : AppColors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isCompleted ? AppColors.white : AppColors.primaryGreen,
            child: Text(
              '$stepNumber',
              style: TextStyle(
                color: isCompleted ? AppColors.primaryGreen : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: isCompleted ? AppColors.primaryGreen : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            Helpers.formatCurrency(amount),
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  )
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeliveryDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && mounted) {
      setState(() => _selectedDeliveryDate = picked);
    }
  }

  void _updateQuantity(String productId, int newQuantity) {
    if (newQuantity > 0) {
      context.read<CartProvider>().updateQuantity(productId, newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, child) {
          final user = authProvider.currentUser;
          
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.lg,
                      bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Summary
                        const Text('Order Summary', style: AppTextStyles.heading3),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: Column(
                            children: [
                              ...cartProvider.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('${item.productTitle} x${item.quantity}')),
                                    Text(Helpers.formatCurrency(item.totalPrice)),
                                  ],
                                ),
                              )),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total', style: AppTextStyles.bodyLarge),
                                  Text(Helpers.formatCurrency(cartProvider.totalAmount), 
                                       style: AppTextStyles.heading3.copyWith(color: AppColors.primaryGreen)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Delivery Information
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.local_shipping, color: AppColors.primaryGreen),
                                  SizedBox(width: AppSpacing.sm),
                                  Text('Delivery Options', style: AppTextStyles.heading3),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              // Express Delivery Toggle
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                  border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Express Delivery', style: AppTextStyles.bodyMedium),
                                          const SizedBox(height: 4),
                                          Text('Get your order in 24 hours', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: _isExpressDelivery,
                                      onChanged: (value) => setState(() => _isExpressDelivery = value),
                                      activeThumbColor: AppColors.primaryGreen,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: AppSpacing.md),

                              // Delivery Date Selection
                              if (!_isExpressDelivery) ...[
                                const Text('Preferred Delivery Date', style: AppTextStyles.bodyMedium),
                                const SizedBox(height: AppSpacing.sm),
                                InkWell(
                                  onTap: () => _selectDeliveryDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                      border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedDeliveryDate != null
                                              ? 'Deliver on ${_formatDate(_selectedDeliveryDate!)}'
                                              : 'Select delivery date',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        const Icon(Icons.calendar_month_outlined, color: AppColors.primaryGreen),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                              ],

                              CustomTextField(
                                controller: _addressController,
                                label: 'Delivery Address',
                                hint: 'Enter your delivery address',
                                maxLines: 3,
                                prefixIcon: Icons.location_on_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter delivery address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              CustomTextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                hint: 'Enter your phone number',
                                keyboardType: TextInputType.phone,
                                prefixIcon: Icons.phone_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              CustomTextField(
                                controller: _emailController,
                                label: 'Email Address (Optional)',
                                hint: 'Enter your email for order updates',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty && !value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Payment Method
                        const Text('Payment Method', style: AppTextStyles.heading3),
                        const SizedBox(height: AppSpacing.md),
                        Column(
                          children: [
                            RadioListTile<String>(
                              title: const Text('Credit/Debit Card'),
                              subtitle: const Text('Pay with Paystack'),
                              value: 'card',
                              groupValue: _paymentMethod,
                              onChanged: (value) => setState(() => _paymentMethod = value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('Bank Transfer'),
                              subtitle: const Text('Pay via bank transfer'),
                              value: 'transfer',
                              groupValue: _paymentMethod,
                              onChanged: (value) => setState(() => _paymentMethod = value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('Pay on Delivery'),
                              subtitle: const Text('Cash payment on delivery'),
                              value: 'cod',
                              groupValue: _paymentMethod,
                              onChanged: (value) => setState(() => _paymentMethod = value!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Place Order Button
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: _isProcessing ? 'Processing...' : 'Place Order',
                      onPressed: _isProcessing ? null : () => _placeOrder(cartProvider, user),
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _placeOrder(CartProvider cartProvider, user) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create order
      final order = OrderModel(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        buyerId: user?.id ?? '',
        buyerName: user?.name ?? '',
        buyerPhone: _phoneController.text,
        buyerLocation: _addressController.text,
        sellerId: 'seller1', // This would come from the products
        sellerName: 'Various Sellers',
        sellerLocation: 'Lagos',
        items: cartProvider.items.map((item) => OrderItem(
          productId: item.productId,
          productTitle: item.productTitle,
          productImage: item.productImage,
          quantity: item.quantity,
          price: item.price,
        )).toList(),
        totalAmount: cartProvider.totalAmount,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        deliveryType: 'okada',
      );

      // Add order to provider
      if (mounted) {
        await context.read<OrderProvider>().createOrder(
          items: cartProvider.items.map((item) => {
            'product': item.productId,
            'quantity': item.quantity,
          }).toList(),
          deliveryAddress: {
            'street': _addressController.text,
            'city': 'Lagos',
            'state': 'Lagos',
          },
          paymentMethod: _paymentMethod,
        );
        cartProvider.clearCart();

        // Show success and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ErrorModal.show(context, 'Error placing order: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

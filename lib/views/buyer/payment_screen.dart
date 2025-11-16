import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/payment_methods.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class PaymentScreen extends StatefulWidget {
  final ProductModel product;
  final int quantity;

  const PaymentScreen({
    super.key,
    required this.product,
    this.quantity = 1,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'paystack';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    final totalAmount = widget.product.price * widget.quantity;
    const deliveryFee = 500.0;
    final finalAmount = totalAmount + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: AppTextStyles.heading3),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.product.images.first,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.title,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${widget.quantity}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Helpers.formatCurrency(totalAmount),
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildPriceRow('Subtotal', totalAmount),
                        _buildPriceRow('Delivery Fee', deliveryFee),
                        const Divider(height: 16),
                        _buildPriceRow('Total', finalAmount, isTotal: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Payment Methods
                  PaymentMethodSelector(
                    onMethodSelected: (method) {
                      setState(() => _selectedPaymentMethod = method);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Pay Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _processPayment(finalAmount),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Pay ${Helpers.formatCurrency(finalAmount)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
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

  void _processPayment(double amount) async {
    setState(() => _isProcessing = true);
    
    try {
      final user = context.read<AuthProvider>().currentUser;
      
      // Create order first
      final order = await context.read<OrderProvider>().createDirectOrder(
        product: widget.product,
        quantity: widget.quantity,
        buyerId: user!.id,
        buyerName: user.name,
        buyerPhone: user.phone ?? '',
        buyerLocation: user.location ?? '',
        paymentMethod: _selectedPaymentMethod,
      );

      // Process payment based on method
      if (_selectedPaymentMethod == 'paystack') {
        // Initialize Paystack payment
        _showPaymentSuccess(order.id);
      } else if (_selectedPaymentMethod == 'cash_on_delivery') {
        _showPaymentSuccess(order.id);
      } else {
        // Handle other payment methods
        _showPaymentSuccess(order.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showPaymentSuccess(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Order #${orderId.substring(0, 8)} has been placed',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
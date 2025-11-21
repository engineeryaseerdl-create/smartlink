import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PaymentMethodSelector extends StatefulWidget {
  final Function(String) onMethodSelected;

  const PaymentMethodSelector({super.key, required this.onMethodSelected});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String _selectedMethod = 'paystack';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'paystack',
          'Paystack',
          'Pay with card or bank transfer',
          Icons.credit_card,
          Colors.blue,
        ),
        _buildPaymentOption(
          'bank_transfer',
          'Bank Transfer',
          'Direct bank transfer',
          Icons.account_balance,
          Colors.green,
        ),
        _buildPaymentOption(
          'cash_on_delivery',
          'Cash on Delivery',
          'Pay when you receive your order',
          Icons.money,
          Colors.orange,
        ),
        _buildPaymentOption(
          'ussd',
          'USSD Payment',
          'Pay using your bank USSD code',
          Icons.phone,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() => _selectedMethod = value);
        widget.onMethodSelected(value);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColors.primaryGreen.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  )),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}

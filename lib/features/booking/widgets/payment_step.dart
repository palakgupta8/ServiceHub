import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/service_model.dart';
import '../../../shared/models/coupon_model.dart';

enum PaymentMethod { upi, card, cash }

class PaymentStep extends StatefulWidget {
  final ServiceModel service;
  final CouponModel? appliedCoupon;
  final PaymentMethod selectedMethod;
  final void Function(PaymentMethod) onMethodSelected;

  const PaymentStep({
    super.key,
    required this.service,
    this.appliedCoupon,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _upiController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double discount =
        widget.appliedCoupon?.discountAmount(widget.service.price) ?? 0;
    final double total = widget.service.price - discount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment', style: AppTextStyles.headingMedium),
          const SizedBox(height: 6),
          Text('Choose your payment method', style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),

          _buildAmountCard(total),
          const SizedBox(height: 24),

          Text('Payment Methods', style: AppTextStyles.headingSmall),
          const SizedBox(height: 14),

          // ── UPI ────────────────────────────────────────────────────────
          _PaymentOptionTile(
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF2DD36F),
            iconBg: const Color(0xFFF0FFF4),
            title: 'UPI',
            subtitle: 'GPay, PhonePe, Paytm & more',
            isSelected: widget.selectedMethod == PaymentMethod.upi,
            onTap: () => widget.onMethodSelected(PaymentMethod.upi),
            expandedContent: widget.selectedMethod == PaymentMethod.upi
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: _upiController,
                      decoration: _inputDecoration('Enter UPI ID (e.g. name@upi)'),
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 12),

          // ── Card ───────────────────────────────────────────────────────
          _PaymentOptionTile(
            icon: Icons.credit_card_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: 'Credit / Debit Card',
            subtitle: 'Visa, Mastercard, RuPay',
            isSelected: widget.selectedMethod == PaymentMethod.card,
            onTap: () => widget.onMethodSelected(PaymentMethod.card),
            expandedContent: widget.selectedMethod == PaymentMethod.card
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        TextField(
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Card Number'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _expiryController,
                                decoration: _inputDecoration('MM / YY'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: _inputDecoration('CVV'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 12),

          // ── Cash on Service ────────────────────────────────────────────
          _PaymentOptionTile(
            icon: Icons.payments_outlined,
            iconColor: const Color(0xFFFF9800),
            iconBg: const Color(0xFFFFF3E0),
            title: 'Cash on Service',
            subtitle: 'Pay cash when the service is done',
            isSelected: widget.selectedMethod == PaymentMethod.cash,
            onTap: () => widget.onMethodSelected(PaymentMethod.cash),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAmountCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF7B8FF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount to Pay',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: AppTextStyles.displayMedium
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          if (widget.appliedCoupon != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_offer_rounded,
                      size: 13, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    widget.appliedCoupon!.code,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}

// ── Payment option tile ──────────────────────────────────────────────────────
class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? expandedContent;

  const _PaymentOptionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.headingSmall),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                // Animated radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                      width: 2,
                    ),
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
            if (expandedContent != null) expandedContent!,
          ],
        ),
      ),
    );
  }
}

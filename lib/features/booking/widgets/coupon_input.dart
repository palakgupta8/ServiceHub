import 'package:flutter/material.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/coupon_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CouponInput extends StatefulWidget {
  final String serviceCategoryId;
  final CouponModel? appliedCoupon;  // null = no coupon applied yet
  final void Function(CouponModel) onApplied;
  final VoidCallback onRemoved;

  const CouponInput({
    super.key,
    required this.serviceCategoryId,
    required this.appliedCoupon,
    required this.onApplied,
    required this.onRemoved,
  });

  @override
  State<CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput> {
  final _controller = TextEditingController();

  // _errorMessage: shown in red under the field
  // _isApplying: shows a small spinner while "validating"
  String? _errorMessage;
  bool _isApplying = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isApplying = true;
      _errorMessage = null;
    });

    // Simulate a small network delay for validation (feels realistic)
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // validateCoupon returns either CouponModel (success) or String (error)
    final result = MockData.validateCoupon(code, widget.serviceCategoryId);

    setState(() => _isApplying = false);

    if (result is CouponModel) {
      // Valid — clear error, notify parent
      setState(() => _errorMessage = null);
      widget.onApplied(result);
      _controller.clear();
      FocusScope.of(context).unfocus(); // dismiss keyboard
    } else if (result is String) {
      // Invalid — show error message
      setState(() => _errorMessage = result);
    }
  }

  void _remove() {
    setState(() => _errorMessage = null);
    _controller.clear();
    widget.onRemoved();
  }

  @override
  Widget build(BuildContext context) {
    // If a coupon is already applied, show the applied chip instead of the input
    if (widget.appliedCoupon != null) {
      return _buildAppliedChip(widget.appliedCoupon!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Coupon text field ──────────────────────────────────────
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                // TextCapitalization.characters: auto-uppercases as user types
                // so "save10" becomes "SAVE10" automatically
                decoration: InputDecoration(
                  hintText: 'Enter coupon code',
                  prefixIcon: const Icon(Icons.local_offer_outlined,
                      size: 18, color: AppColors.textSecondary),
                  // Show error border when there's an error message
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errorMessage != null
                          ? AppColors.error
                          : AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _errorMessage != null
                          ? AppColors.error
                          : AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                onSubmitted: (_) => _apply(),
              ),
            ),

            const SizedBox(width: 10),

            // ── Apply button ───────────────────────────────────────────
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isApplying ? null : _apply,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 54),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: _isApplying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text('Apply', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),

        // ── Error message ────────────────────────────────────────────────
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 14, color: AppColors.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],

        // ── Available coupons hint ────────────────────────────────────────
        const SizedBox(height: 10),
        Text(
          'Try: SAVE10 • FIRST50 • CLEAN20 • SUMMER30',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // Shown after a coupon is successfully applied
  Widget _buildAppliedChip(CouponModel coupon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 20, color: AppColors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.code,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  coupon.description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          // Remove button
          GestureDetector(
            onTap: _remove,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close_rounded,
                  size: 18, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

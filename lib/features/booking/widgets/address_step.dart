import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_text_field.dart';

enum AddressType { home, office, other }

class AddressStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController pincodeController;
  final AddressType selectedAddressType;
  final void Function(AddressType) onAddressTypeChanged;

  const AddressStep({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.pincodeController,
    required this.selectedAddressType,
    required this.onAddressTypeChanged,
  });

  @override
  State<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Address', style: AppTextStyles.headingMedium),
            const SizedBox(height: 4),
            Text(
              'Where should our professional come?',
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(height: 24),

            AppTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: widget.nameController,
              prefixIcon: Icons.person_outline,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),

            const SizedBox(height: 18),

            AppTextField(
              label: 'Phone Number',
              hint: '10-digit mobile number',
              controller: widget.phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Phone is required';
                if (v.length < 10) return 'Enter a valid 10-digit number';
                return null;
              },
            ),

            const SizedBox(height: 18),

            AppTextField(
              label: 'Full Address',
              hint: 'House no., street, area...',
              controller: widget.addressController,
              prefixIcon: Icons.location_on_outlined,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Address is required' : null,
            ),

            const SizedBox(height: 18),

            // City and Pincode side by side
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    label: 'City',
                    hint: 'Your city',
                    controller: widget.cityController,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    label: 'Pincode',
                    hint: '6-digit code',
                    controller: widget.pincodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v.length < 6) return 'Invalid';
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Address type selector ──────────────────────────────────
            Text('Address Type', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            Row(
              children: AddressType.values.map((type) {
                final bool isSelected = widget.selectedAddressType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onAddressTypeChanged(type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: type != AddressType.values.last ? 10 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _iconForType(type),
                            size: 22,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _labelForType(type),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(AddressType type) {
    switch (type) {
      case AddressType.home: return Icons.home_outlined;
      case AddressType.office: return Icons.business_outlined;
      case AddressType.other: return Icons.location_on_outlined;
    }
  }

  String _labelForType(AddressType type) {
    switch (type) {
      case AddressType.home: return 'Home';
      case AddressType.office: return 'Office';
      case AddressType.other: return 'Other';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/data/mock_data.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/coupon_model.dart';
import 'widgets/step_indicator.dart';
import 'widgets/date_time_step.dart';
import 'widgets/address_step.dart';
import 'widgets/review_step.dart';

class BookingScreen extends StatefulWidget {
  final String serviceId;

  const BookingScreen({super.key, required this.serviceId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // ── Step tracking ──────────────────────────────────────────────────────
  int _currentStep = 0;
  static const int _totalSteps = 3;

  // ── Step 1 state ───────────────────────────────────────────────────────
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  // ── Step 2 state ───────────────────────────────────────────────────────
  // GlobalKey for step 2's Form — used to validate before advancing
  final _addressFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  AddressType _addressType = AddressType.home;

  // ── Coupon state ───────────────────────────────────────────────────────
  CouponModel? _appliedCoupon;

  // ── Loading state ──────────────────────────────────────────────────────
  bool _isConfirming = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  // ── Step navigation ────────────────────────────────────────────────────
  void _onNextPressed() {
    if (_currentStep == 0) {
      // Validate step 1: both date and time slot must be selected
      if (_selectedDate == null || _selectedTimeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date and time slot'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    if (_currentStep == 1) {
      // Validate step 2's Form using its GlobalKey
      if (!_addressFormKey.currentState!.validate()) return;
    }

    if (_currentStep == 2) {
      _confirmBooking();
      return;
    }

    // Advance to next step with animation
    setState(() => _currentStep++);
  }

  void _onBackPressed() {
    if (_currentStep == 0) {
      context.pop(); // exit booking screen entirely
    } else {
      setState(() => _currentStep--);
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _isConfirming = true);
    // Simulate API call to create booking
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _isConfirming = false);

    // Replace booking screen with success screen
    // go() replaces the whole stack — user can't press back to booking
    context.go(AppRoutes.bookingSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final ServiceModel? service = MockData.serviceById(widget.serviceId);

    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Service not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: _onBackPressed,
        ),
        title: Text('Book Service', style: AppTextStyles.headingMedium),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: StepIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // ── Step content ─────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              // AnimatedSwitcher: animates between step widgets
              // When _currentStep changes → old step fades out, new step fades in
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                // SlideTransition + FadeTransition combined:
                // new step slides in from right while fading in
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _buildCurrentStep(service),
            ),
          ),

          // ── Bottom action button ─────────────────────────────────────
          _buildBottomButton(service),
        ],
      ),
    );
  }

  // Returns the widget for the current step
  // key: ValueKey(_currentStep) tells AnimatedSwitcher that this is a NEW child
  // Without the key, AnimatedSwitcher can't tell the widgets apart and won't animate
  Widget _buildCurrentStep(ServiceModel service) {
    switch (_currentStep) {
      case 0:
        return DateTimeStep(
          key: const ValueKey(0),
          service: service,
          selectedDate: _selectedDate,
          selectedTimeSlot: _selectedTimeSlot,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          onTimeSlotSelected: (slot) => setState(() => _selectedTimeSlot = slot),
        );
      case 1:
        return AddressStep(
          key: const ValueKey(1),
          formKey: _addressFormKey,
          nameController: _nameController,
          phoneController: _phoneController,
          addressController: _addressController,
          cityController: _cityController,
          pincodeController: _pincodeController,
          selectedAddressType: _addressType,
          onAddressTypeChanged: (type) => setState(() => _addressType = type),
        );
      case 2:
        return ReviewStep(
          key: const ValueKey(2),
          service: service,
          selectedDate: _selectedDate!,
          selectedTimeSlot: _selectedTimeSlot!,
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          city: _cityController.text,
          pincode: _pincodeController.text,
          addressType: _addressType,
          appliedCoupon: _appliedCoupon,
          onCouponApplied: (coupon) => setState(() => _appliedCoupon = coupon),
          onCouponRemoved: () => setState(() => _appliedCoupon = null),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _buildButtonLabel(bool isLastStep, ServiceModel service) {
    if (!isLastStep) return 'Next';
    if (_appliedCoupon == null) return 'Confirm Booking — ${service.formattedPrice}';
    final total = _appliedCoupon!.finalPrice(service.price);
    return 'Confirm Booking — ₹${total.toStringAsFixed(0)}';
  }

  Widget _buildBottomButton(ServiceModel service) {
    final bool isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.paddingM, 12, AppConstants.paddingM, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: ElevatedButton(
        onPressed: _isConfirming ? null : _onNextPressed,
        child: _isConfirming
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(_buildButtonLabel(isLastStep, service)),
      ),
    );
  }
}

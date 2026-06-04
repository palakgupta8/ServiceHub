import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;        // shows eye icon + toggles obscureText
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData? prefixIcon;
  final String? Function(String?)? validator; // null = no validation
  final VoidCallback? onEditingComplete;      // called when user taps "next/done" on keyboard
  final List<TextInputFormatter>? inputFormatters; // e.g. digits-only for phone

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.validator,
    this.onEditingComplete,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // _obscureText: only matters for password fields
  // Starts as true (hidden) — user taps eye to reveal
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the field
        Text(widget.label, style: AppTextStyles.labelMedium),
        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller,
          // obscureText: true = shows ● ● ● instead of characters
          // For non-password fields, always false
          // For password fields, toggles based on _obscureText
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          onEditingComplete: widget.onEditingComplete,
          style: AppTextStyles.bodyMedium,

          decoration: InputDecoration(
            hintText: widget.hint,

            // prefixIcon: icon on the left side of the field
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon,
                    size: 20, color: AppColors.textSecondary)
                : null,

            // suffixIcon: only shown on password fields — the eye toggle
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      // Toggle password visibility
                      // setState only rebuilds THIS widget, not the whole screen
                      setState(() => _obscureText = !_obscureText);
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
          ),

          // validator: runs when form.validate() is called
          // Return a String = show error message
          // Return null = field is valid
          validator: widget.validator,
        ),
      ],
    );
  }
}

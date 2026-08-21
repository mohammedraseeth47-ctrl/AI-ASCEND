import 'package:flutter/material.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';

class TrackGoTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final FocusNode? focusNode;

  const TrackGoTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<TrackGoTextField> createState() => _TrackGoTextFieldState();
}

class _TrackGoTextFieldState extends State<TrackGoTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          enabled: widget.enabled,
          style: AppTypography.bodyLarge,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.textSecondaryLight,
                    size: 20,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

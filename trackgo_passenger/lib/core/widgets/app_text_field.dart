import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable search and form text field.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool readOnly;
  final bool autofocus;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.readOnly = false,
    this.autofocus = false,
    this.prefixIcon,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
  });

  const AppTextField.search({
    super.key,
    this.controller,
    this.hintText = 'Search bus lines, stops, or destinations...',
    this.onChanged,
    this.onTap,
    this.onClear,
    this.readOnly = false,
    this.autofocus = false,
    this.prefixIcon = Icons.search_rounded,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.search,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      autofocus: autofocus,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: AppTextStyles.bodyLarge.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                size: 22,
              )
            : null,
        suffixIcon: suffix ??
            (controller != null && controller!.text.isNotEmpty && onClear != null
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    onPressed: onClear,
                  )
                : null),
      ),
    );
  }
}

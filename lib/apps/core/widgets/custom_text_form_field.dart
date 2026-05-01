import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.hint,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.controller,
    this.inputType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.inputFormatters = const [],
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: prefix,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.bgGray,
        // Adding a slight border so the field is visible on white backgrounds
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

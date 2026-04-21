import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  const CustomPasswordTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.hint,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hint;
  final Widget? prefixIcon;

  @override
  State<CustomPasswordTextFormField> createState() =>
      _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hint: widget.hint ?? 'Password',
      inputType: TextInputType.visiblePassword,
      isPassword: _isPasswordHidden,
      prefix: widget.prefixIcon,
      suffix: InkWell(
        onTap: () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          });
        },
        child: _isPasswordHidden
            ? const Icon(Icons.visibility_outlined, color: Colors.grey)
            : const Icon(Icons.visibility_off_outlined, color: Colors.grey),
      ),
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            } else if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
    );
  }
}

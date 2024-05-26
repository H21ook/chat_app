import 'package:flutter/material.dart';

class CustomTextFormInput extends StatelessWidget {
  final String? labelText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  const CustomTextFormInput(
      {Key? key,
      this.labelText,
      this.validator,
      this.controller,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: const OutlineInputBorder(),
        isDense: true,
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}

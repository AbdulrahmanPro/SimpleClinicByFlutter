import 'package:flutter/material.dart';

// استراتيجية لتحديد الأيقونات
abstract class IconStrategy {
  Widget buildIcon(bool isVisible);
}

class PasswordIconStrategy implements IconStrategy {
  @override
  Widget buildIcon(bool isVisible) {
    return Icon(isVisible ? Icons.visibility : Icons.visibility_off);
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconStrategy? iconStrategy; // إضافة استراتيجية

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.iconStrategy,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller ?? TextEditingController(),
      obscureText: widget.isPassword && !show,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    show = !show;
                  });
                },
                icon: widget.iconStrategy
                        ?.buildIcon(show) ??
                    Icon(show ? Icons.visibility : Icons.visibility_off),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: widget.validator,
    );
  }
}

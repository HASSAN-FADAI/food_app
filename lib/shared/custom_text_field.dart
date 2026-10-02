import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hunhry_food/core/constants/app_color.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
  });
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the ${widget.hintText}';
        }

        return null;
      },
      controller: widget.controller,
      obscureText: _obscureText,
      cursorHeight: 20,
      cursorColor: AppColor.primary,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(CupertinoIcons.eye),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade800),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}

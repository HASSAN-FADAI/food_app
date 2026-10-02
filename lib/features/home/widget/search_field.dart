import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onChanged});
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      cursorHeight: 20,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        prefixIcon: const Icon(CupertinoIcons.search, color: Colors.white),
        hintText: 'Search..',
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double borderRadius;
  final double fieldPadding;
  final double hintSize;
  final TextInputType textType;

  const CustomTextFormField(
      {super.key,
      required this.controller,
      this.hintSize = 25,
      this.fieldPadding = 10,
      required this.hintText,
      this.borderRadius = 30,
      this.textType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textType,
      style: GoogleFonts.alef(
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontSize: 25,
      ),
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 20, vertical: fieldPadding),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
                color: Colors.black, style: BorderStyle.solid, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
                color: Colors.black, width: 2, style: BorderStyle.solid)),
        hintText: hintText,
        hintStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w400,
          color: const Color(0xff91919F),
          fontSize: hintSize,
        ),
      ),
      cursorColor: const Color(0xff00A86B),
    );
  }
}

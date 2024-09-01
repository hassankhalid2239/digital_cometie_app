import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color bgColor;
  final Color titleColor;
  final Color borderColor;
  final double btnElevation;
  final double titleSize;
  const CustomElevatedButton(
      {super.key,
      required this.title,
      this.borderColor=Colors.transparent,
      this.titleSize = 25,
      required this.onTap,
      this.bgColor = const Color(0xff003CBE),
      this.titleColor = Colors.white,
      this.btnElevation = 1});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(width: 1,color: borderColor)),
          elevation: WidgetStatePropertyAll(btnElevation),
          backgroundColor: WidgetStatePropertyAll(bgColor),
        ),
        child: Text(
          title,
          style: GoogleFonts.alef(
              fontSize: titleSize,
              fontWeight: FontWeight.w400,
              color: titleColor,
              letterSpacing: 2),
        )
    );

  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFilterButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;
  const CustomFilterButton({super.key, required this.title, required this.bgColor, required this.borderColor, required this.textColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderColor),
          color: bgColor
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              title,
              style:GoogleFonts.roboto(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

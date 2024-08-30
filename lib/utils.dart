import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black54,
        content: Text(message,style: GoogleFonts.alef(
          color: Colors.white,
          fontWeight: FontWeight.w400,
    ),)));
  }
}

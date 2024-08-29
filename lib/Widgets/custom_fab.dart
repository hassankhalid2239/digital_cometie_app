import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  final VoidCallback onTap;
  const CustomFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: FloatingActionButton(
        onPressed: onTap,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff003CBE),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

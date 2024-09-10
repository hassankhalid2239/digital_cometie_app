import 'package:digital_cometie_app/Animations/fade_transitions.dart';
import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {

  final String image ;
  const ImageBuilder({super.key,required this.image });

  @override
  Widget build(BuildContext context) {
    return FadeTransAnimation(
      child: Image(
        fit: BoxFit.fill,
        repeat: ImageRepeat.repeatY,
        image:  NetworkImage(image),
        errorBuilder: (BuildContext context, Object exception,
            StackTrace? stackTrace) {
          return SizedBox(
              child: Image.asset('assets/images/pfavatar.png', fit: BoxFit.cover));
        },
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child ;
          return SizedBox(
              child: Image.asset('assets/images/pfavatar.png', fit: BoxFit.cover));
        },
      ),
    );
  }
}
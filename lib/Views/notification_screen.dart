import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  final String? title;
  final String? body;
  const NotificationScreen({super.key,this.body, this.title});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE9F0FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: SvgPicture.asset('assets/svg/popicon.svg',height: 20,width: 20,),
          )
        ),
        surfaceTintColor: Colors.transparent,
        title: Text('Notification Screen',style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            color: Colors.black
        ),),
        centerTitle: true,
      ),
    );
  }
}

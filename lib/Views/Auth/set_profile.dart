import 'package:digital_cometie_app/Views/Auth/set_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/custom_fab.dart';
import '../../Widgets/custom_text_form_field.dart';

class SetProfile extends StatelessWidget {
  SetProfile({super.key});
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffE9F0FF),
          foregroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 315,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xffE9F0FF),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Center(
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage('assets/images/setprofile.png'),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Set Profile',
                        style: GoogleFonts.lora(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CustomTextFormField(
                    controller: _nameController, hintText: 'Enter Name'),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFab(
          onTap: () {
            if (_nameController.text.isNotEmpty) {
              Get.to(SetLocation(name: _nameController.text,));
            } else {
              Get.snackbar(
                'Required',
                'Field should not be empty!',
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
                icon: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
                colorText: Colors.pinkAccent,
              );
            }
          },
        ));
  }
}

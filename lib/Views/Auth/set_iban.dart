import 'package:digital_cometie_app/Animations/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/auth_controller.dart';
import '../../Modals/user_model.dart';
import '../../Widgets/custom_fab.dart';
import '../../Widgets/custom_text_form_field.dart';
import '../main_page.dart';

class SetIban extends StatelessWidget {
  SetIban({super.key,required this.location,required this.name});
  final String location;
  final String name;
  final _authController =Get.put(AuthController());
  final TextEditingController _ibanController = TextEditingController();
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
              FadeAnimation(
                1,
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
                        FadeAnimation(
                          1,
                           const Image(
                            image: AssetImage('assets/images/setiban.png'),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1,
                           Text(
                            'Set IBAN',
                            style: GoogleFonts.lora(
                                fontWeight: FontWeight.w400,
                                fontSize: 40,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: FadeAnimation2(
                  2,
                   CustomTextFormField(
                      controller: _ibanController, hintText: 'Enter IBAN'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        floatingActionButton: Obx((){
          if(_authController.loading.value==true){
            return const CircularProgressIndicator(color:Color(0xff003CBE) ,);
          }else{
             return CustomFab(
               onTap: () {
                 if (_ibanController.text.isNotEmpty) {
                   UserModel userModel= UserModel(
                       name: name,
                       location: location,
                       iban: _ibanController.text.trim(),
                       phone: "",
                       profilePic: "",
                       uid: "",
                       createdAt: "");
                   _authController.storeUserData(
                       context: context,
                       userModel: userModel,
                       onSuccess: (){
                         Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (context) =>  MainPage()),
                                 (route) => false);
                       });
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
             );
          }
        })
    );
  }
}

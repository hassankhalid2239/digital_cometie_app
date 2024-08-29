
import 'package:digital_cometie_app/Views/Auth/set_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/auth_controller.dart';
import '../../Widgets/custom_elevated_button.dart';
import '../../Widgets/custom_text_form_field.dart';
import '../main_page.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key,required this.verificationId});
  final String verificationId;
  final TextEditingController _otpController = TextEditingController();
  final _authController=Get.put(AuthController());

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
                      image: AssetImage('assets/images/signup.png'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Authentication',
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
                  controller: _otpController, hintText: 'Enter 6 digit OTP',textType: TextInputType.number,),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx((){
              if(_authController.loading==true){
                return CircularProgressIndicator(color:Color(0xff003CBE) ,);
              }else{
                return CustomElevatedButton(
                    title: 'Verify',
                    onTap: () {
                      if (_otpController.text.isNotEmpty) {
                        _authController.verifyOtp(
                            context: context,
                            verificationId: verificationId,
                            userOtp: _otpController.text.trim(),
                            onSuccess: (){
                              _authController.checkExitingUser().then((value)async{
                                if(value==true){
                                  //user Exit
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  MainPage()),
                                          (route) => false);
                                }else{
                                  //New User
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => SetProfile()),
                                          (route) => false);
                                }
                              });
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
                    });
              }
            })
          ],
        ),
      ),
    );
  }
}

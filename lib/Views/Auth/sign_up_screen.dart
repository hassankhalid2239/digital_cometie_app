import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/auth_controller.dart';
import '../../Controller/state_controller.dart';
import '../../Widgets/custom_elevated_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController _phoneController = TextEditingController();
  final _stateController =Get.put(StateController());
  final _authController =Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE9F0FF),
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
                      'Sign Up',
                      style: GoogleFonts.lora(
                          fontWeight: FontWeight.w400,
                          fontSize: 50,
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
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _phoneController,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 25,
                ),
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: (){
                        showCountryPicker(context: context,
                            countryListTheme: CountryListThemeData(
                              bottomSheetHeight: 550
                            ),
                            onSelect: (value){
                          _stateController.selectedCountry.value=value;
                            }
                        );
                      },
                      child: Obx((){
                        return Text("${_stateController.selectedCountry.value.flagEmoji} + ${_stateController.selectedCountry.value.phoneCode}",style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),);
                      }),
                    ),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.black, style: BorderStyle.solid, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.black, width: 2, style: BorderStyle.solid)),
                  hintText: 'Enter Phone Number',
                  hintStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff91919F),
                    fontSize: 25,
                  ),
                ),

                cursorColor: const Color(0xff00A86B),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx((){
              if(_authController.loading==true){
                return CircularProgressIndicator(color:Color(0xff003CBE) ,);
              }else{
                return CustomElevatedButton(
                    title: 'Sign Up',
                    onTap: () {
                      if (_phoneController.text.isNotEmpty) {
                        String phoneNumber= _phoneController.text.trim();
                        _authController.signInWithPhone(context, "+${_stateController.selectedCountry.value.phoneCode}${phoneNumber}");
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

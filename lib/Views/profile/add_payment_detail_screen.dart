// ignore_for_file: deprecated_member_use

import 'package:digital_cometie_app/Controller/payment_controller.dart';
import 'package:digital_cometie_app/Widgets/custom_elevated_button.dart';
import 'package:digital_cometie_app/Widgets/custom_text_form_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/auth_controller.dart';

class AddPaymentDetailScreen extends StatelessWidget {
  final String cometieId;
  final String paymentIndex;
  AddPaymentDetailScreen({super.key,required this.cometieId,required this.paymentIndex});

  final TextEditingController _transactionIdText=TextEditingController();
  final TextEditingController _amountText=TextEditingController();
  final _paymentController = Get.put(PaymentController());
  final _authController = Get.put(AuthController());
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
              onPressed: () {
                Get.back();
                _paymentController.screenshotFile.value=null;
              },
              icon: SvgPicture.asset(
                'assets/svg/popicon.svg',
                height: 20,
                width: 20,
              ),
            )),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Add Payment Detail',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DottedBorder(
                color: const Color(0xff003CBE),
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                dashPattern: const [14, 7],
                strokeCap: StrokeCap.round,
                strokeWidth: 2,
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child:ElevatedButton(
                    style: ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        // splashColor: Color(0xff5800FF),
                        padding:
                        const MaterialStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: MaterialStatePropertyAll(Color(0xffE9F0FF)),
                        shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _paymentController.pickImageCamera();
                                    // pickImageCamera();
                                    Navigator.pop(context);
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.zero),
                                    shape: MaterialStatePropertyAll(
                                        BeveledRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    // splashFactory: InkSplash.splashFactory,
                                    splashFactory: InkSparkle.splashFactory,
                                    overlayColor:
                                    MaterialStatePropertyAll(
                                        Color(0xffE9F0FF)),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color:
                                      Theme.of(context).colorScheme.outline,
                                    ),
                                    title: Text('Take profile picture',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18)),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // pickImage();
                                    _paymentController.pickImage();
                                    Navigator.pop(context);
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.zero),
                                    shape: MaterialStatePropertyAll(
                                        BeveledRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    // splashFactory: InkSplash.splashFactory,
                                    splashFactory: InkSparkle.splashFactory,
                                    overlayColor:
                                    MaterialStatePropertyAll(
                                        Color(0xffE9F0FF)),
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.photo_library,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                    title: Text('Select profile picture',
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18)),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_rounded,
                          color: Colors.grey,
                          size: 25,
                        ),
                        Obx((){
                          if(_paymentController.screenshotFile.value==null){
                            return Text(
                              'Drop Screenshot',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                height: 2,
                                color: Colors.grey,
                              ),
                            );
                          }else{
                            return Text(
                              _paymentController.screenshotName.toString(),
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                height: 2,
                                color: Colors.black,
                              ),
                            );
                          }
                        })

                      ],
                    )
                  )
                ),
              ),
              SizedBox(height: 15,),
              Text(
                'Transaction Id',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                  textType: TextInputType.number,
                  controller: _transactionIdText, hintText: 'Enter Transaction Id'),
              SizedBox(height: 15,),
              Text(
                'Amount',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                  textType: TextInputType.number,
                  controller: _amountText, hintText: 'Enter Amount'),
              SizedBox(height: 25,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Obx((){
                  if(_authController.loading.value==true) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color(0xff003CBE),
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,),
                      ),
                    );
                  }else{
                    return CustomElevatedButton(
                        title: 'Submit', onTap: (){
                          String amount=_amountText.text.trim();
                          if(_amountText.text!='' && _transactionIdText.text!=''){
                            if(_paymentController.screenshotFile.value!=null){
                              _paymentController.uploadPaymentData(
                                  cometieId,
                                  paymentIndex,
                                  _transactionIdText.text,
                                  int.parse(amount));
                            }else{
                              Get.snackbar(
                                'Oh!',
                                "Please select the image!",
                                backgroundColor: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                ),
                                colorText: Colors.pinkAccent,
                              );
                            }
                          }else{
                            Get.snackbar(
                              'Oh!',
                              "Fields are Required!",
                              backgroundColor: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

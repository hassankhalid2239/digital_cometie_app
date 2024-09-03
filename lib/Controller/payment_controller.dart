import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_controller.dart';
import 'cometie_controller.dart';
import 'notification_controller.dart';



class PaymentController extends GetxController{
  final _stateController = Get.put(StateController());
  final _authController = Get.put(AuthController());
  final _cometieController = Get.put(CometieController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString screenshotUrl = ''.obs;
  RxString shotUrl = ''.obs;
  RxString screenshotName = ''.obs;
  Rx<File?> screenshotFile = Rx<File?>(null);

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      cropImage(image.path);
      screenshotName.value=image.name;
    } catch (e) {
      Get.snackbar(
        'Oh!',
        e.toString(),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        // duration: const Duration(seconds: 1),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: Colors.pinkAccent,
      );
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      cropImage(image.path);
      screenshotName.value=image.name;
    } catch (e) {
      Get.snackbar(
        'Oh!',
        e.toString(),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        // duration: const Duration(seconds: 1),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: Colors.pinkAccent,
      );
    }
  }

  Future cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage == null) {
      screenshotFile.value = null;
    }
    if (croppedImage != null) {
      screenshotFile.value = File(croppedImage.path);
      // uploadProfileData();
      print('Updatedddddddddddd');
    }
  }


  Future uploadPaymentData(String cometieId, String paymentIndex,String transactionId,int amount) async {
    try {
      _authController.loading.value=true;
      final ref = FirebaseStorage.instance
          .ref()
          .child('PaymentsScreenshots')
          .child('${_authController.userModel.uid}.jpg');
      if (screenshotFile.value != null) {
        await ref.putFile(screenshotFile.value!);
        screenshotUrl.value = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('Cometies').doc(cometieId).collection('Members').doc(_authController
        .userModel.uid).collection('Payments').doc(paymentIndex).update({
          'screenshot': screenshotUrl.value,
          'transactionId': transactionId,
          'amount': amount,
          'paymentDate' : DateTime.now(),
        });
        Notifications().sendPaymentPaid(cometieId, paymentIndex);
        Future.delayed(const Duration(seconds: 1)).then((value) {
          _authController.loading.value=false;
          Get.snackbar(
            'Congrats',
            "Changes saved successfully",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
            ),
            colorText: Colors.pinkAccent,
          );
        });
        _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(_authController.userModel.uid).collection('Payments').doc(paymentIndex).update({
          'paymentConfirmation': 'Pending',
        });
      }
    } on FirebaseAuthException catch (e) {
      _authController.loading.value=false;
      if (e.message ==
          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
        Get.snackbar(
          'Oh!',
          "No Internet Connection",
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          // duration: const Duration(seconds: 1),
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),
          colorText: Colors.pinkAccent,
        );
      } else {
        Get.snackbar(
          'Oh!',
          e.toString(),
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          // duration: const Duration(seconds: 1),
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),
          colorText: Colors.pinkAccent,
        );
      }
    }
  }


}
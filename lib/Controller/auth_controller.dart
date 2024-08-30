import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Modals/user_model.dart';
import '../Views/Auth/otp_screen.dart';
import '../services/notification_services.dart';
import 'notification_controller.dart';

class AuthController extends GetxController {
  RxBool loading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _notificationServices = NotificationServices();
  String? _uid;
  String get uid => _uid!;
  RxString imageUrl=''.obs;
  RxString imgUrl=''.obs;
  Rx<File?> imageFile = Rx<File?>(null);
  final Rx<UserModel> _userModel = UserModel(
          name: '',
          location: '',
          iban: '',
          phone: '',
          profilePic: '',
          uid: '',
          createdAt: '')
      .obs;
  UserModel get userModel => _userModel.value;



  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      loading.value = true;
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            // throw Exception(error.message);
            Get.snackbar(
              'Oh!',
              error.toString(),
              backgroundColor: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              // duration: const Duration(seconds: 1),
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
              colorText: Colors.pinkAccent,
            );
            loading.value = false;
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OtpScreen(verificationId: verificationId)));
            loading.value = false;
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
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
      loading.value = false;
    }
  }
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    try {
      loading.value = true;
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _auth.signInWithCredential(creds)).user;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      loading.value = false;
    } on FirebaseAuthException catch (e) {
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
      loading.value = false;
    }
  }
  Future<bool> checkExitingUser() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Users').doc(_uid).get();
    if (snapshot.exists) {
      _notificationServices.getDeviceToken().then((token)async{
        await FirebaseFirestore.instance.collection('UserToken').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'token': token,
        });
      });
      return true;
    } else {
      return false;
    }
  }
  void storeUserData(
      {required BuildContext context,
      required UserModel userModel,
      required Function onSuccess}) async {
    loading.value = true;
    try {
      userModel.createdAt = DateTime.now().toString();
      userModel.phone = _auth.currentUser!.phoneNumber.toString();
      userModel.uid = _auth.currentUser!.uid.toString();
      _userModel.value = userModel;
      // _userModel=userModel;

      await _firestore
          .collection("Users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        loading.value = false;
      });
      _notificationServices.getDeviceToken().then((token)async{
        await FirebaseFirestore.instance.collection('UserToken').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'token': token,
          'id' : FirebaseAuth.instance.currentUser!.uid
        });
      });
    } on FirebaseAuthException catch (e) {
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
      loading.value = false;
    }
  }
  Future getUserData() async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel.value = UserModel(
          name: snapshot['name'],
          location: snapshot['location'],
          iban: snapshot['iban'],
          phone: snapshot['phone'],
          profilePic: snapshot['profilePic'],
          uid: snapshot['uid'],
          createdAt: snapshot['createdAt']);
      _uid = _userModel.value.uid;
    });
  }
  Future<String?> getUserToken(String documentId) async {
    try {
      // Firestore collection reference
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('UserToken') // Replace with your collection name
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        // Assuming the token is stored with the key 'token' in the document
        return documentSnapshot.get('token');
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching token: $e");
      return null;
    }
  }
  Future userSignOut() async {
    await _auth.signOut();
  }
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      cropImage(image.path);
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
      imageFile.value=null;
    }
    if (croppedImage != null) {
      imageFile.value=File(croppedImage.path);
      uploadProfileData();
      print('Updatedddddddddddd');
    }
  }
  Future uploadProfileData() async {
    try {
      loading.value=true;
      final User? user = _auth.currentUser;
      final uid = user!.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child('userProfileImages')
          .child('$uid.jpg');
      if (imageFile.value != null) {
        await ref.putFile(imageFile.value!);
        imageUrl.value = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'profilePic': imageUrl.value,
        });
        Future.delayed(const Duration(seconds: 1)).then((value) {
          loading.value=false;
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
      }
    } on FirebaseAuthException catch (e) {
      loading.value=false;
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
  void deletePF() {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    try {
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'profilePic': '',
      });
      Get.snackbar(
        'Congrats',
        'Changes saved successfully',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        // duration: const Duration(seconds: 1),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: Colors.pinkAccent,
      );
    }on FirebaseAuthException catch(e){
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



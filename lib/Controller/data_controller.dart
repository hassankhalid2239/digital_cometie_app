import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DataController extends GetxController{
  RxString name=''.obs;
  RxString location=''.obs;
  RxString iban=''.obs;
  RxString phone=''.obs;
  RxString profilePic=''.obs;
  RxString uid=''.obs;
  RxString createdAt=''.obs;

  void getData()async{
    DocumentSnapshot snap=await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    name.value=snap['name'];
    location.value=snap['location'];
    iban.value=snap['iban'];
    phone.value=snap['phone'];
    profilePic.value=snap['profilePic'];
    uid.value=snap['uid'];
    createdAt.value=snap['createdAt'];
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/toast.dart';
import 'auth_controller.dart';

class CometieController extends GetxController{
  final _stateController= Get.put(StateController());
  final _authController= Get.put(AuthController());
  RxBool loading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList members=[].obs;


  void storeCometieData({
    required String name,
    required int amount,
    required int duration,
    required String status,
})async{
      DateTime completeDate=calculateReminderDate(Timestamp.now().toDate());
      String id = DateTime.now().millisecondsSinceEpoch.toString();
    try{
      await _firestore.collection('Cometies').doc(id).set({
        "cometieName":name,
        "amount":amount*_stateController.currentValue.round(),
        'eachAmount':amount,
        "duration":duration,
        'creatorProfilePic':_authController.userModel.profilePic,
        "status":status,
        'creatorLocation':_authController.userModel.location,
        "uid":_auth.currentUser!.uid,
        "cometieId":id,
        "launchedAt":members.length==_stateController.currentValue.round()?
            Timestamp.now():Timestamp.now(),
        "createdAt":Timestamp.now(),
        "completedAt":Timestamp.now(),
      });

      for(int i=0; i<members.length; i++){
        _firestore.collection('Cometies').doc(id).collection('Members').doc(members[i]['memberUid']).set({
          "memberUid":members[i]['memberUid'],
          "memberName":members[i]['memberName'],
          "memberProfilePic":members[i]['memberProfilePic'],
          "memberPhone":members[i]['memberPhone'],
        });

      }

      for(int i=0;i<members.length; i++){
        var snap=await _firestore.collection('Cometies').doc(id).collection('Members').get();
        for(int j=0;j<_stateController.currentValue.round();j++){
          _firestore.collection('Cometies').doc(id).collection('Members').doc(snap.docs[i].id).collection('Payments').doc('Payment ${j+1}').set({
            "amount":amount,
            "paymentIndex":'${j+1}',
            "transactionId":'',
            "paymentStatus": 'Unpaid',
            "paymentDate":''
          });
        }
      }
      Toast().showToastMessage('Cometie upload successfully');
    }on FirebaseAuthException catch(e){
      Get.snackbar(
        'Oh!',
        e.toString(),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: Colors.pinkAccent,
      );
    }
    members.clear();
  }

  DateTime calculateReminderDate(DateTime startDate) {
    // Adding 3 months to the input date
    DateTime reminderDate = DateTime(
      startDate.year,
      startDate.month + _stateController.currentValue.round(),
      startDate.day,
    );

    return reminderDate;
  }
  Stream<QuerySnapshot> getCometieData() {
    return FirebaseFirestore.instance
        .collection('Cometies')
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
  }
  Stream<DocumentSnapshot> getCometieDetail(String cometieId) {
    return FirebaseFirestore.instance
        .collection('Cometies')
        .doc(cometieId)
        .snapshots();
  }

}
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:digital_cometie_app/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils.dart';
import 'auth_controller.dart';
import 'package:rxdart/rxdart.dart';

class CometieController extends GetxController {
  final _stateController = Get.put(StateController());
  final _authController = Get.put(AuthController());
  final _notificationServices = NotificationServices();
  RxBool loading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList members = [].obs;

  void storeCometieData({
    required String name,
    required int amount,
    required int duration,
    required String status,
  }) async {
    loading.value = true;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    for (int i = 0; i < members.length; i++) {
      if (members[i]['memberUid'] != _auth.currentUser!.uid) {
        await _firestore
            .collection('UserToken')
            .doc(members[i]['memberUid'])
            .get()
            .then((snap) {
          String token = snap['token'];
          _notificationServices.sendNotificationToUsers(
              '${_authController.userModel.name} added you.',
              'Now you are the member of $name.',
              [token]);
          _firestore
              .collection('Users')
              .doc(members[i]['memberUid'])
              .collection('Notifications')
              .doc(id)
              .set({
            'senderId': _authController.userModel.uid,
            'cometeId': id,
            'title': '${_authController.userModel.name} added you.',
            'body': 'Now you are the member of $name.',
            'arrived': DateTime.now(),
            'notificationId': id,
            'response': 'acceptRequest',
            'type': 'Added'
          });
        });
      }
    }

    try {
      await _firestore.collection('Cometies').doc(id).set({
        "cometieName": name,
        "amount": amount * _stateController.currentValue.round(),
        'eachAmount': amount,
        "duration": duration,
        'creatorProfilePic': _authController.userModel.profilePic,
        "status": status,
        'creatorLocation': _authController.userModel.location,
        "uid": _auth.currentUser!.uid,
        "cometieId": id,
        "launchedAt": members.length == _stateController.currentValue.round()
            ? Timestamp.now()
            : Timestamp.now(),
        "createdAt": Timestamp.now(),
        "completedAt": members.length == _stateController.currentValue.round()
            ? calculateReminderDate(Timestamp.now().toDate())
            : Timestamp.now()
      });

      for (int i = 0; i < members.length; i++) {
        _firestore
            .collection('Users')
            .doc(members[i]['memberUid'])
            .collection('JoinedCometies')
            .doc(id)
            .set({
          "cometieId": id,
        });
        _firestore
            .collection('Cometies')
            .doc(id)
            .collection('Members')
            .doc(members[i]['memberUid'])
            .set({
          "memberUid": members[i]['memberUid'],
          "memberName": members[i]['memberName'],
          "memberProfilePic": members[i]['memberProfilePic'],
          "memberPhone": members[i]['memberPhone'],
        });
      }

      for (int i = 0; i < members.length; i++) {
        var snap = await _firestore
            .collection('Cometies')
            .doc(id)
            .collection('Members')
            .get();
        for (int j = 0; j < _stateController.currentValue.round(); j++) {
          _firestore
              .collection('Cometies')
              .doc(id)
              .collection('Members')
              .doc(snap.docs[i].id)
              .collection('Payments')
              .doc('Payment ${j + 1}')
              .set({
            "amount": amount,
            "paymentIndex": '${j + 1}',
            "transactionId": '',
            "paymentStatus": 'Unpaid',
            "paymentDate": '',
            "screenshot": '',
            'paymentConfirmation': '',
            'enable':false,
          });
        }
      }
      Utils().showToastMessage('Cometie upload successfully');
    } on FirebaseAuthException catch (e) {
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
    loading.value = false;
  }

  Future<bool> checkPreviousRequest(String cometieId) async {
    var document = await FirebaseFirestore.instance
        .collection("Users")
        .doc(_authController.userModel.uid)
        .collection("CometieRequestSent")
        .doc(cometieId)
        .get();
    if (document.exists) {
      return true;
    } else {
      return false;
    }
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getCometies() {
    if (_stateController.cometieFilterIndex.value == 1) {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .where('status', whereIn: ['Progress', 'Completed'])
          .orderBy(
            'createdAt',
          )
          .snapshots();
    } else if (_stateController.cometieFilterIndex.value == 2) {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .where('status', whereIn: ['Progress', 'Completed'])
          .orderBy('creatorLocation')
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .where('status', whereIn: ['Progress', 'Completed']).snapshots();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> viewAllCometies() {
    if (_stateController.cometieFilterIndex.value == 1) {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .where('status', isEqualTo: 'Pending')
          .orderBy(
        'createdAt',
      )
          .snapshots();
    } else if (_stateController.cometieFilterIndex.value == 2) {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .where('status', isEqualTo: 'Pending')
          .orderBy('creatorLocation')
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .where('status', isEqualTo: 'Pending').snapshots();
    }
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>>
      getCometiesReport() async* {
    // Get the IDs of the cometies the user has joined
    var cometieSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('JoinedCometies')
        .get();

    // Collect cometie IDs
    List<String> cometieKeys =
        cometieSnapshot.docs.map((doc) => doc.id).toList();

    // If no cometie keys are found, yield an empty list
    if (cometieKeys.isEmpty) {
      yield [];
      return;
    }

    // Stream for each cometie document
    List<Stream<DocumentSnapshot<Map<String, dynamic>>>> cometieStreams =
        cometieKeys.map((id) {
      return FirebaseFirestore.instance
          .collection('Cometies')
          .doc(id)
          .snapshots();
    }).toList();

    // Combine all streams into one that emits a list of snapshots
    yield* CombineLatestStream.list(cometieStreams)
        .map((snapshots) => snapshots);
  }
}

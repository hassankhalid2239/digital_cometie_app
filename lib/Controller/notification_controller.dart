import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/notification_services.dart';

class Notifications{

  final _notificationServices = NotificationServices();
  final _authController = Get.put(AuthController());
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  final FirebaseAuth _auth= FirebaseAuth.instance;


  sendJoinOffer(String cometieName,String receiverId,String cometieId)async{
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token= userToken!;
    _notificationServices.sendNotificationToUsers(_authController.userModel.name, '${_authController.userModel.name} wants to join your $cometieName.', [token]);
      _firestore.collection('Users').doc(receiverId).collection('Notifications').doc(id).set({
        'senderId': _authController.userModel.uid,
        'cometeId': cometieId,
        'title' : _authController.userModel.name,
        'body': '${_authController.userModel.name} wants to join your $cometieName.',
        'arrived':DateTime.now(),
        'notificationId': id,
        'response':''
      });
    _firestore.collection('Users').doc(_authController.userModel.uid).collection('CometieRequestSent').doc(cometieId).set({});
  }
  sendCancelOffer(String cometieName,String receiverId,String cometieId,String notificationId)async{
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token= userToken!;
    _notificationServices.sendNotificationToUsers(_authController.userModel.name, '${_authController.userModel.name} wants to join your $cometieName.', [token]);
    _firestore.collection('Users').doc(receiverId).collection('Notifications').doc(id).set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'title' : '${_authController.userModel.name} cancel request!',
      'body': '$cometieName members limit is full.',
      'arrived':DateTime.now(),
      'notificationId': id,
    });
    _firestore.collection('Users').doc(receiverId).collection('Notifications').doc(notificationId).update({
      'response':'false'
    });
    _firestore.collection('Users').doc(receiverId).collection('CometieRequestSent').doc(cometieId).set({
      'response': 'Rejected'
    });
  }

}
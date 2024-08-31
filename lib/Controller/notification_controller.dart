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

  // send when user join cometie request send
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
        'response':'pending',
        'type': 'cometieRequest'
      });
  }
  // send when creator cancel join cometie request
  sendCancelOffer(String cometieName,String receiverId,String cometieId,String notificationId)async{
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token= userToken!;
    _notificationServices.sendNotificationToUsers('${_authController.userModel.name} cancel your request!', "You can't join $cometieName due to any reason", [token]);
    _firestore.collection('Users').doc(receiverId).collection('Notifications').doc(id).set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'title' : '${_authController.userModel.name} cancel your request!',
      'body': "You can't join $cometieName due to any reason",
      'arrived':DateTime.now(),
      'notificationId': id,
      'type': 'cancelRequest'
    });
    _firestore.collection('Users').doc(_auth.currentUser!.uid).collection('Notifications').doc(notificationId).update({
      'response':'cancel'
    });
  }
  // send when creator accept join cometie request
  sendAcceptOffer(String cometieName,String receiverId,String cometieId,String notificationId)async{
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token= userToken!;
    _notificationServices.sendNotificationToUsers('${_authController.userModel.name} cancel your request', 'Now you are the member of $cometieName', [token]);
    _firestore.collection('Users').doc(receiverId).collection('Notifications').doc(id).set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'title' : '${_authController.userModel.name} accept request!',
      'body': 'Now you are the member of $cometieName',
      'arrived':DateTime.now(),
      'notificationId': id,
      'type': 'acceptRequest'
    });
    _firestore.collection('Users').doc(_auth.currentUser!.uid).collection('Notifications').doc(notificationId).update({
      'response':'accept'
    });
    var snap= await _firestore.collection('Users').doc(receiverId).get();
    var user = snap.data()!;
    _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(receiverId).set({
      "memberUid":receiverId,
      "memberName": user['name'],
      "memberProfilePic":user['profilePic'],
      "memberPhone":user['phone'],
    });
    var shot= await _firestore.collection('Cometies').doc(cometieId).get();
    var cometie = shot.data()!;
    for(int j=0;j<cometie['duration'];j++){
      _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(receiverId).collection('Payments').doc('Payment ${j+1}').set({
        "amount":cometie['eachAmount'],
        "paymentIndex":'${j+1}',
        "transactionId":'',
        "paymentStatus": 'Unpaid',
        "paymentDate":''
      });
    }
  }

}
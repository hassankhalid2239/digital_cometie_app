import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/auth_controller.dart';
import 'package:digital_cometie_app/Controller/cometie_controller.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/notification_services.dart';
import '../utils.dart';

class Notifications {
  final _notificationServices = NotificationServices();
  final _authController = Get.put(AuthController());
  final _cometieController = Get.put(CometieController());
  final _stateController = Get.put(StateController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // calculate completing date
  DateTime calculateReminderDate(DateTime startDate, int duration) {
    // Adding 3 months to the input date
    DateTime reminderDate = DateTime(
      startDate.year,
      startDate.month + duration,
      startDate.day,
    );

    return reminderDate;
  }

  // get Notification List
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications() {
    if (_stateController.notifyFilterIndex.value == 1) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(_authController.userModel.uid)
          .collection('Notifications')
          .where('type', isEqualTo: 'cometieRequest')
          .orderBy('arrived', descending: true)
          .snapshots();
    } else if (_stateController.notifyFilterIndex.value == 2) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(_authController.userModel.uid)
          .collection('Notifications')
          .where('type', isEqualTo: 'acceptRequest')
          .orderBy('arrived', descending: true)
          .snapshots();
    } else if (_stateController.notifyFilterIndex.value == 3) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(_authController.userModel.uid)
          .collection('Notifications')
          .where('type', isEqualTo: 'cancelRequest')
          .orderBy('arrived', descending: true)
          .snapshots();
    } else if (_stateController.notifyFilterIndex.value == 4) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(_authController.userModel.uid)
          .collection('Notifications')
          .where('type', isEqualTo: 'Added')
          .orderBy('arrived', descending: true)
          .snapshots();
    } else if (_stateController.notifyFilterIndex.value == 5) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(_authController.userModel.uid)
          .collection('Notifications')
          .where('type', isEqualTo: 'paymentAlert')
          .orderBy('arrived', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(_authController.userModel.uid)
          .collection('Notifications')
          .orderBy('arrived', descending: true)
          .snapshots();
    }
  }

  Future<int> getMemberLength(String cometieId) async {
    var snapshot = await _firestore
        .collection('Cometies')
        .doc(cometieId)
        .collection('Members')
        .get();
    int length = snapshot.docs.length;
    return length;
  }

  // send when user join cometie request send
  sendJoinOffer(String cometieName, String receiverId, String cometieId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token = userToken!;
    _notificationServices.sendNotificationToUsers(
        _authController.userModel.name,
        '${_authController.userModel.name} wants to join your $cometieName.',
        [token]);
    _firestore
        .collection('Users')
        .doc(receiverId)
        .collection('Notifications')
        .doc(id)
        .set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'title': _authController.userModel.name,
      'body':
          '${_authController.userModel.name} wants to join your $cometieName.',
      'arrived': DateTime.now(),
      'notificationId': id,
      'response': 'pending',
      'type': 'cometieRequest'
    });
  }

  // send when creator cancel join cometie request
  sendCancelOffer(String cometieName, String receiverId, String cometieId,
      String notificationId) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token = userToken!;
    _notificationServices.sendNotificationToUsers(
        '${_authController.userModel.name} cancel your request!',
        "You can't join $cometieName due to any reason",
        [token]);
    _firestore
        .collection('Users')
        .doc(receiverId)
        .collection('Notifications')
        .doc(id)
        .set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'title': '${_authController.userModel.name} cancel your request!',
      'body': "You can't join $cometieName due to any reason",
      'arrived': DateTime.now(),
      'notificationId': id,
      'type': 'cancelRequest'
    });
    _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Notifications')
        .doc(notificationId)
        .update({'response': 'cancel'});
  }

  // send when creator accept join cometie request
  sendAcceptOffer(String cometieName, String receiverId, String cometieId,
      String notificationId) async {
    var snapshot = await _firestore
        .collection('Cometies')
        .doc(cometieId)
        .collection('Members')
        .get();
    int membersLength = snapshot.docs.length;
    var shot = await _firestore.collection('Cometies').doc(cometieId).get();
    var cometie = shot.data()!;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token = userToken!;
    if (cometie['duration'] != membersLength) {
      _notificationServices.sendNotificationToUsers(
          '${_authController.userModel.name} Accept your request',
          'Now you are the member of $cometieName',
          [token]);
      _firestore
          .collection('Users')
          .doc(receiverId)
          .collection('Notifications')
          .doc(id)
          .set({
        'senderId': _authController.userModel.uid,
        'cometeId': cometieId,
        'title': '${_authController.userModel.name} accept request!',
        'body': 'Now you are the member of $cometieName',
        'arrived': DateTime.now(),
        'notificationId': id,
        'type': 'acceptRequest'
      });
      _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notifications')
          .doc(notificationId)
          .update({'response': 'accept'});
      var snap = await _firestore.collection('Users').doc(receiverId).get();
      var user = snap.data()!;
      _firestore
          .collection('Cometies')
          .doc(cometieId)
          .collection('Members')
          .doc(receiverId)
          .set({
        "memberUid": receiverId,
        "memberName": user['name'],
        "memberProfilePic": user['profilePic'],
        "memberPhone": user['phone'],
      });
      _firestore
          .collection('Users')
          .doc(receiverId)
          .collection('JoinedCometies')
          .doc(id)
          .set({
        "cometieId": cometieId,
      });
      for (int j = 0; j < cometie['duration']; j++) {
        _firestore
            .collection('Cometies')
            .doc(cometieId)
            .collection('Members')
            .doc(receiverId)
            .collection('Payments')
            .doc('Payment ${j + 1}')
            .set({
          "amount": cometie['eachAmount'],
          "paymentIndex": '${j + 1}',
          "transactionId": '',
          "paymentStatus": 'Unpaid',
          "paymentDate": '',
          "screenshot": '',
          'paymentConfirmation': '',
          'enable':false,
        });
      }
      getMemberLength(cometieId).then((value) async {
        if (value == cometie['duration']) {
          await _firestore.collection('Cometies').doc(cometieId).update({
            'status': 'Progress',
            'launchedAt': Timestamp.now(),
            'completedAt': calculateReminderDate(
                Timestamp.now().toDate(), cometie['duration'])
          });
        }
      });
    } else {
      Utils().showToastMessage('Members Limit is full');
      sendCancelOffer(cometieName, receiverId, cometieId, notificationId);
    }
  }


  // send for payment alert
  sendPaymentAlert(String memberUid, String index,String cometieId)async{
    _cometieController.loading.value=true;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(memberUid);
    String token = userToken!;
    var snap= await _firestore.collection('Cometies').doc(cometieId).get();
    var cometie= snap.data()!;
    _notificationServices.sendNotificationToUsers(
        'Payment Alert!',
        'Lets pay the $index of Cometie ${cometie['cometieName']}',
        [token]);
    _firestore
        .collection('Users')
        .doc(memberUid)
        .collection('Notifications')
        .doc(id)
        .set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'payment' : index,
      'title': 'Payment Alert!',
      'body': 'Lets pay the $index of Cometie ${cometie['cometieName']}',
      'arrived': DateTime.now(),
      'notificationId': id,
      'type': 'paymentAlert'
    });
    await _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(memberUid).collection('Payments').doc(index).update({
      'enable': true,
      'paymentConfirmation' : 'Pending'
    });
    _cometieController.loading.value=false;
    Utils().showToastMessage('Payment Alert sent');
  }

  // send when payment is paid from user side
  sendPaymentPaid(String cometieId,String paymentIndex)async{
    var snap = await _firestore.collection('Cometies').doc(cometieId).get();
    var cometie= snap.data()!;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(cometie['uid']);
    String token = userToken!;
    _notificationServices.sendNotificationToUsers(
        'Confirm Payment!',
        'Lets confirm the $paymentIndex of Cometie ${cometie['cometieName']}',
        [token]);
    _firestore
        .collection('Users')
        .doc(cometie['uid'])
        .collection('Notifications')
        .doc(id)
        .set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'payment' : paymentIndex,
      'title': 'Confirm Payment!',
      'body': 'Lets confirm the $paymentIndex of Cometie ${cometie['cometieName']}',
      'arrived': DateTime.now(),
      'notificationId': id,
      'type': 'paymentConfirm'
    });
    _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(cometie['uid']).collection('Payments').doc(paymentIndex).update({
      'paymentConfirmation': 'Pending',
    });
  }

  //send when creator not  received payment
  sendPaymentCancelConfirm(String cometieId,String paymentIndex,String receiverId)async{
    var snap = await _firestore.collection('Cometies').doc(cometieId).get();
    var cometie= snap.data()!;
    var snapshot = await _firestore.collection('Users').doc(cometie['uid']).get();
    var user= snapshot.data()!;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token = userToken!;
    _notificationServices.sendNotificationToUsers(
        'Payment Confirmation!',
        '${user['name']} not receive $paymentIndex of Cometie ${cometie['cometieName']}',
        [token]);
    _firestore
        .collection('Users')
        .doc(receiverId)
        .collection('Notifications')
        .doc(id)
        .set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'payment' : paymentIndex,
      'title': 'Payment Confirmation!',
      'body': '${user['name']} not receive $paymentIndex of Cometie ${cometie['cometieName']}',
      'arrived': DateTime.now(),
      'notificationId': id,
      'type': 'paymentAlert'
    });
    _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(receiverId).collection('Payments').doc(paymentIndex).update({
      'paymentConfirmation': 'NotConfirmed',
    });
  }

  //send when creator   received payment
  sendPaymentConfirm(String index,String cometieId,String receiverId)async{
    var snap = await _firestore.collection('Cometies').doc(cometieId).get();
    var cometie= snap.data()!;
    var snapshot = await _firestore.collection('Users').doc(cometie['uid']).get();
    var user= snapshot.data()!;
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String? userToken = await _authController.getUserToken(receiverId);
    String token = userToken!;
    _notificationServices.sendNotificationToUsers(
        'Payment Confirmation!',
        '${user['name']} received $index of Cometie ${cometie['cometieName']}',
        [token]);
    _firestore
        .collection('Users')
        .doc(receiverId)
        .collection('Notifications')
        .doc(id)
        .set({
      'senderId': _authController.userModel.uid,
      'cometeId': cometieId,
      'payment' : index,
      'title': 'Payment Confirmation!',
      'body': '${user['name']} received $index of Cometie ${cometie['cometieName']}',
      'arrived': DateTime.now(),
      'notificationId': id,
      'type': 'paymentReceived'
    });

    _firestore.collection('Cometies').doc(cometieId).collection('Members').doc(receiverId).collection('Payments').doc(index).update({
      'enable': false,
      'paymentStatus': 'Paid',
      'paymentConfirmation': 'Confirmed',
    });
  }

}

// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Animations/fade_animation.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:digital_cometie_app/Views/my_payment_detail_screen.dart';
import 'package:digital_cometie_app/Widgets/custom_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controller/auth_controller.dart';
import '../../Controller/notification_controller.dart';
import '../confirm_payment_screen.dart';
import 'others_profile_screen.dart';

class NotificationListScreen extends StatelessWidget {
  NotificationListScreen({super.key});

  final _authController=Get.put(AuthController());
  final _stateController=Get.put(StateController());

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
                _stateController.notifyFilterIndex.value=0;
              },
              icon: SvgPicture.asset(
                'assets/svg/popicon.svg',
                height: 20,
                width: 20,
              ),
            )),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Notifications',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.square(40),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Obx((){
                   return  CustomFilterButton(
                       onTap: (){
                         _stateController.notifyFilterIndex.value=0;
                       },
                       title: 'All',
                       bgColor: _stateController.notifyFilterIndex.value==0?const Color(0xff003CBE):Colors.transparent,
                       borderColor: _stateController.notifyFilterIndex.value==0?Colors.transparent:Colors.grey,
                       textColor: _stateController.notifyFilterIndex.value==0?Colors.white:Colors.black);
                 }),
                  const SizedBox(width: 10,),
                  Obx((){
                    return CustomFilterButton(
                        onTap: (){
                          _stateController.notifyFilterIndex.value=1;
                        },
                        title: 'Cometie Requests',
                        bgColor: _stateController.notifyFilterIndex.value==1?const Color(0xff003CBE):Colors.transparent,
                        borderColor: _stateController.notifyFilterIndex.value==1?Colors.transparent:Colors.grey,
                        textColor: _stateController.notifyFilterIndex.value==1?Colors.white:Colors.black                  );
                  }),
                  const SizedBox(width: 10,),
                  Obx((){
                    return CustomFilterButton(
                        onTap: (){
                          _stateController.notifyFilterIndex.value=2;
                        },
                        title: 'Accepted',
                        bgColor: _stateController.notifyFilterIndex.value==2?const Color(0xff003CBE):Colors.transparent,
                        borderColor: _stateController.notifyFilterIndex.value==2?Colors.transparent:Colors.grey,
                        textColor: _stateController.notifyFilterIndex.value==2?Colors.white:Colors.black
                    );
                  }),
                  const SizedBox(width: 10,),
                  Obx((){
                    return CustomFilterButton(
                        onTap: (){
                          _stateController.notifyFilterIndex.value=3;
                        },
                        title: 'Rejected',
                        bgColor: _stateController.notifyFilterIndex.value==3?const Color(0xff003CBE):Colors.transparent,
                        borderColor: _stateController.notifyFilterIndex.value==3?Colors.transparent:Colors.grey,
                        textColor: _stateController.notifyFilterIndex.value==3?Colors.white:Colors.black
                    );
                  }),
                  const SizedBox(width: 10,),
                  Obx((){
                    return CustomFilterButton(
                        onTap: (){
                          _stateController.notifyFilterIndex.value=4;
                        },
                        title: 'Joined You',
                        bgColor: _stateController.notifyFilterIndex.value==4?const Color(0xff003CBE):Colors.transparent,
                        borderColor: _stateController.notifyFilterIndex.value==4?Colors.transparent:Colors.grey,
                        textColor: _stateController.notifyFilterIndex.value==4?Colors.white:Colors.black
                    );
                  }),
                  const SizedBox(width: 10,),
                  Obx((){
                    return CustomFilterButton(
                        onTap: (){
                          _stateController.notifyFilterIndex.value=5;
                        },
                        title: 'Payments',
                        bgColor: _stateController.notifyFilterIndex.value==5?const Color(0xff003CBE):Colors.transparent,
                        borderColor: _stateController.notifyFilterIndex.value==5?Colors.transparent:Colors.grey,
                        textColor: _stateController.notifyFilterIndex.value==5?Colors.white:Colors.black
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx((){
        return StreamBuilder(
          stream: Notifications().getNotifications(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(color: Colors.white,height: 1,),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return FadeAnimation2(
                      1.2,
                       Dismissible(
                        // background: Container(color: Colors.red,),
                        key: Key(snapshot.data.docs[index]['notificationId']),
                        onDismissed: (direction) {
                          CollectionReference ref = FirebaseFirestore.instance
                              .collection("Users")
                              .doc(_authController.userModel.uid)
                              .collection("Notifications");
                          ref
                              .doc(snapshot.data!.docs[index]['notificationId'].toString())
                              .delete();
                        },
                        child: ListTile(
                          tileColor: const Color(0xffE9F0FF),
                          onTap: () async {
                            DocumentSnapshot uDoc = await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(_authController.userModel.uid)
                                .collection('Notifications')
                                .doc(snapshot.data.docs[index]['notificationId'])
                                .get();
                            DocumentSnapshot snap = await FirebaseFirestore.instance
                                .collection('Cometies')
                                .doc(snapshot.data?.docs[index]['cometeId'])
                                .get();
                            if(snapshot.data?.docs[index]['type']=='cometieRequest'){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OthersProfileScreen(
                                            id: uDoc['senderId'],
                                            notificationId: snapshot.data.docs[index]['notificationId'],
                                            cometieIid: snapshot.data?.docs[index]['cometeId'],
                                            cometieName: snap['cometieName'],
                                            response: snapshot.data?.docs[index]['response'],
                                          )));
                            }else if(snapshot.data?.docs[index]['type']=='paymentAlert'){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyPaymentDetailScreen(
                                            creatorId: snap['uid'],
                                            memberUid: _authController.userModel.uid, cometieId: uDoc['cometeId'],
                                          )));
                            } else if(snapshot.data?.docs[index]['type']=='paymentConfirm') {
                              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(snapshot.data!.docs[index]['senderId'])
                                  .get();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConfirmPaymentScreen(
                                            cometieId: uDoc['cometeId'],
                                            notificationId: snapshot.data!.docs[index]['notificationId'],
                                            receiverId:snapshot.data!.docs[index]['senderId'],
                                            paymentIndex: snapshot.data!.docs[index]['payment'],
                                            receiverName: userDoc['name'] ,
                                          )));
                            }else{
                              return;
                            }

                          },
                          // leading: CircleAvatar(
                          //     radius: 22,
                          //     child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(22),
                          //         child: snapshot.data.docs[index]['UserImage'] ==
                          //             ""
                          //             ? const Icon(
                          //           Icons.person,
                          //           size: 25,
                          //           color: Colors.black12,
                          //         )
                          //             : Image.network(
                          //             snapshot.data.docs[index]['UserImage']))),
                          title: Text('${snapshot.data?.docs[index]['title']}',
                            style: GoogleFonts.dmSans(
                                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),),
                          subtitle: Text('${snapshot.data?.docs[index]['body']}',
                              style: GoogleFonts.dmSans(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('There is no Notification!',
                      style: Theme.of(context).textTheme.labelMedium),
                );
              }
            }
            return Center(
              child: Text('Something went wrong',
                  style: Theme.of(context).textTheme.labelMedium),
            );
          },
        );
      }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/auth_controller.dart';
import '../Controller/cometie_controller.dart';
import '../Controller/notification_controller.dart';
import '../services/notification_services.dart';
import 'others_profile_screen.dart';

class NotificationListScreen extends StatelessWidget {
  NotificationListScreen({super.key});

  final _authController=Get.put(AuthController());

  final _cometieController=Get.put(CometieController());

  final _notificationServices = NotificationServices();

  final _notificationController = Get.put(Notifications());

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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(_authController.userModel.uid)
            .collection('Notifications')
            .orderBy('arrived', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
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
                      tileColor: Color(0xffE9F0FF),
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
      ),
    );
  }
}

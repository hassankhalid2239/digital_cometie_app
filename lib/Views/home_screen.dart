import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/notification_controller.dart';
import 'package:digital_cometie_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/auth_controller.dart';
import '../Controller/cometie_controller.dart';
import '../services/notification_services.dart';
import 'Auth/sign_up_screen.dart';
import 'cometie_info_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authController=Get.put(AuthController());
  final _cometieController=Get.put(CometieController());
  final _notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    _authController.getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // RecipeDetailAppBar(),
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 450,
            // expandedHeight: 275,
            // backgroundColor: Colors.green,
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            toolbarHeight: 0,
            stretch: true,
            flexibleSpace: SafeArea(
              child: FlexibleSpaceBar(
                background: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.only(top: 10),
                      leading: Obx((){
                        return CircleAvatar(
                            radius: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: _authController.userModel.profilePic != ''
                                  ? Image.network(_authController.userModel.profilePic,
                                  fit: BoxFit.cover)
                                  : Image.asset('assets/images/pfavatar.png', fit: BoxFit.cover),
                            ));
                      }),
                      title: Obx((){
                        return Text(
                          // 'Hi, User',
                          'Hi, ${_authController.userModel.name}',
                          // 'Hi, ${_data.name.value}',
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationListScreen()));
                          },
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            // Icons.notifications_none_sharp,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Cometies',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Cometies').where('status',isEqualTo: 'Pending').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                if(snapshot.data?.docs[index]['uid']!=_authController.userModel.uid){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: SizedBox(
                                      width: 160,
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        color: const Color(0xffE9F0FF),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: snapshot.data?.docs[index]['creatorProfilePic']==''?
                                                AssetImage('assets/images/pfavatar.png'):
                                                NetworkImage(snapshot.data?.docs[index]['creatorProfilePic']),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                snapshot.data?.docs[index]['cometieName'],
                                                // 'Name',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                snapshot.data?.docs[index]['creatorLocation'],
                                                // 'Location',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${snapshot.data?.docs[index]['duration'].toString()} Months',
                                                // 'Duration',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${snapshot.data?.docs[index]['eachAmount'].toString()}',
                                                overflow: TextOverflow.ellipsis,// 'Amount',
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: SizedBox(
                                                  height: 25,
                                                  width: 60,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              backgroundColor: Color(0xffE9F0FF),
                                                              title: Text(
                                                                'Join Cometie',
                                                                style: GoogleFonts.alef(
                                                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                                                              ),
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                              content: Text('Would you like to join this cometie?',style: GoogleFonts.alef(fontWeight: FontWeight.w400,fontSize: 15),),
                                                              actionsPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed: (){
                                                                      _cometieController.checkPreviousRequest(snapshot.data?.docs[index]['cometieId']).then((value){
                                                                        if(value==true){
                                                                          Navigator.pop(context);
                                                                          Utils().showToastMessage('Already request sent!');
                                                                        }else{
                                                                          _authController.loading.value==true;
                                                                          Notifications().sendJoinOffer(
                                                                              snapshot.data?.docs[index]['cometieName'],
                                                                              snapshot.data?.docs[index]['uid'],
                                                                              snapshot.data?.docs[index]['cometieId']
                                                                          );
                                                                          _authController.loading.value==false;
                                                                          Navigator.pop(context);
                                                                          Utils().showSnackBar(context, 'Cometie Join request sent');
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Obx((){
                                                                      if(_authController.loading.value==true){
                                                                        return const CircularProgressIndicator();
                                                                      }else{
                                                                        return Text('Join',style: GoogleFonts.alef(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 18
                                                                        ),);
                                                                      }
                                                                    })
                                                                ),
                                                                TextButton(
                                                                  onPressed: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text('Cancel',style: GoogleFonts.alef(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 18
                                                                  ),),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    style: const ButtonStyle(
                                                      padding: WidgetStatePropertyAll(
                                                          EdgeInsets.zero),
                                                      backgroundColor: WidgetStatePropertyAll(
                                                          Color(0xff003CBE)),
                                                    ),
                                                    child: Text(
                                                      'Add',
                                                      style: GoogleFonts.alef(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.white,
                                                          letterSpacing: 2),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                               return SizedBox();
                              },
                            );

                          } else {
                            return Center(child: Text('Something went wrong!'));
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 70,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.black, width: 1),
                              bottom: BorderSide(color: Colors.black, width: 1))),
                      child: const Center(
                        child: Text('Add'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('Cometies').where('status',isEqualTo: 'Completed')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final cometies = snapshot.data!.docs;
                  if (cometies.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }
                  return  Card(
                    color: const Color(0xffE9F0FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 30,
                    shadowColor: Colors.black,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: 1,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cometies.length,
                      itemBuilder: (context, index) {
                        var cometieData = cometies[index].data() as Map<String, dynamic>;
                        return ListTile(
                          tileColor: const Color(0xffE9F0FF),
                          // contentPadding: const EdgeInsets.only(right: 15),
                          leading: CircleAvatar(
                            backgroundImage: snapshot.data?.docs[index]['creatorProfilePic']==''?
                            AssetImage('assets/images/pfavatar.png'):
                            NetworkImage(snapshot.data?.docs[index]['creatorProfilePic']),
                          ),
                          title: Text(
                            cometieData['cometieName'],
                            style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          subtitle: Text(
                            'Amount: ${cometieData['amount'].toString()}',
                            style: GoogleFonts.roboto(
                              // fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          trailing: Container(
                            // height: 20,
                            // width: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(30),
                                color: cometieData['status']=='Pending'?
                                Colors.redAccent :cometieData['status']=='Progress'?
                                Colors.green:const Color(0xff003CBE)
                            ),
                            child: Text(
                              cometieData['status'],
                              style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );

                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}

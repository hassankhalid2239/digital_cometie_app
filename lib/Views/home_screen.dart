import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/auth_controller.dart';
import '../Controller/data_controller.dart';
import '../services/notification_services.dart';
import 'Auth/sign_up_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authController=Get.put(AuthController());
  final _data=Get.put(DataController());
  final _notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationServices.requestNotificationPermission();
    _notificationServices.getDeviceToken().then((token)=>print('ToKen:${token.toString()}'));
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    _data.getData();
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
                                    builder: (context) => NotificationScreen()));
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
                                                  onPressed: () {},
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
            child: Card(
              color: const Color(0xffE9F0FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 30,
              shadowColor: const Color(0xff003CBE),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                    height: 1,
                  ),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: const Color(0xffE9F0FF),
                      contentPadding: const EdgeInsets.only(right: 15),
                      leading: const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/pfavatar.png'),
                      ),
                      title: Text(
                        'User Name',
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
                            style: GoogleFonts.roboto(
                                // fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text(
                            'Amount',
                            style: GoogleFonts.roboto(
                                // fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CometieInfoScreen()));
                        },
                        icon: SvgPicture.asset('assets/svg/info.svg'),
                      ),
                    );
                  },
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class RecipeDetailAppBar extends StatelessWidget {
  RecipeDetailAppBar({super.key});
  final _authController =Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    _authController.getUserData();
    return SliverAppBar(
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
                leading: CircleAvatar(
                    radius: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: _authController.userModel.profilePic != ''
                          ? Image.network(_authController.userModel.profilePic,
                          fit: BoxFit.cover)
                          : Image.asset('assets/images/pfavatar.png', fit: BoxFit.cover),
                    )),
                title: Obx((){
                  return Text(
                    // 'Hi, User',
                    'Hi, ${_authController.userModel.name}',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      _authController.userSignOut().then((value){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) =>  SignUpScreen()),
                                (route) => false);
                      });
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => NotificationScreen()));
                    },
                    icon: const Icon(
                      Icons.login,
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
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (context, index) {
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
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/pfavatar.png'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Name',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Location',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Duration',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Amount',
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
                                      onPressed: () {},
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
    );
  }
}

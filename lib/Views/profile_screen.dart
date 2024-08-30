// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/auth_controller.dart';
import '../Controller/state_controller.dart';
import 'Auth/sign_up_screen.dart';
import 'cometie_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authController=Get.put(AuthController());
  final _stateController = Get.put(StateController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Color(0xffE9F0FF),
                statusBarIconBrightness: Brightness.dark,
              ),
              automaticallyImplyLeading: false,
              expandedHeight: 580,
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
                          AppBar(
                            backgroundColor: const Color(0xffE9F0FF),
                            elevation: 0,
                            surfaceTintColor: Colors.transparent,
                            title: Text(
                              'Profile',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400, color: Colors.black),
                            ),
                            centerTitle: true,
                            actions: [
                              IconButton(onPressed: (){
                                _authController.userSignOut().then((value){
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  SignUpScreen()),
                                          (route) => false);
                                });
                              }, icon: const Icon(Icons.logout,color: Colors.black,))
                            ],
                          ),
                          const Image(
                            image: AssetImage('assets/images/pfpic.png'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Color(0xffE9F0FF),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                )),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  _authController.pickImageCamera();
                                                  // pickImageCamera();
                                                  Navigator.pop(context);
                                                },
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStatePropertyAll(Colors.white),
                                                  padding: WidgetStatePropertyAll(
                                                      EdgeInsets.zero),
                                                  shape: MaterialStatePropertyAll(
                                                      BeveledRectangleBorder(
                                                          borderRadius: BorderRadius.zero)),
                                                  // splashFactory: InkSplash.splashFactory,
                                                  splashFactory: InkSparkle.splashFactory,
                                                  overlayColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xffE9F0FF)),
                                                ),
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.camera_alt,
                                                    color:
                                                    Theme.of(context).colorScheme.outline,
                                                  ),
                                                  title: Text('Take profile picture',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18)),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // pickImage();
                                                  _authController.pickImage();
                                                  Navigator.pop(context);
                                                },
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStatePropertyAll(Colors.white),
                                                  padding: MaterialStatePropertyAll(
                                                      EdgeInsets.zero),
                                                  shape: MaterialStatePropertyAll(
                                                      BeveledRectangleBorder(
                                                          borderRadius: BorderRadius.zero)),
                                                  // splashFactory: InkSplash.splashFactory,
                                                  splashFactory: InkSparkle.splashFactory,
                                                  overlayColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xffE9F0FF)),
                                                ),
                                                child: ListTile(
                                                  leading: Icon(Icons.photo_library,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline),
                                                  title: Text('Select profile picture',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18)),
                                                ),
                                              ),
                                              Obx((){
                                                if(_authController.userModel.profilePic==''){
                                                  if(_authController.imageFile.value==null){
                                                    return const SizedBox();
                                                  }else{
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        _authController.imageFile.value =
                                                        null;
                                                        // setState(() {
                                                        //   imageFile = null;
                                                        // });
                                                        Navigator.pop(context);
                                                      },
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.white),
                                                        padding:
                                                        WidgetStatePropertyAll(
                                                            EdgeInsets.zero),
                                                        shape:
                                                        WidgetStatePropertyAll(
                                                            BeveledRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .zero)),
                                                        // splashFactory: InkSplash.splashFactory,
                                                        splashFactory:
                                                        InkSparkle.splashFactory,
                                                        overlayColor:
                                                        MaterialStatePropertyAll(
                                                            Color(0xffE9F0FF)),
                                                      ),
                                                      child: ListTile(
                                                        leading: Icon(
                                                            Icons.delete_forever,
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .outline),
                                                        title: Text(
                                                            'Delete profile image',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 18)),
                                                      ),
                                                    );
                                                  }
                                                }else{
                                                  return  ElevatedButton(
                                                    onPressed: () {
                                                      _authController.deletePF();
                                                      _authController.userModel.profilePic =
                                                      '';
                                                      _authController.imageFile.value =
                                                      null;
                                                      _authController.imageUrl.value = '';
                                                      Navigator.pop(context);
                                                    },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white),
                                                      padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.zero),
                                                      shape: MaterialStatePropertyAll(
                                                          BeveledRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.zero)),
                                                      // splashFactory: InkSplash.splashFactory,
                                                      splashFactory:
                                                      InkSparkle.splashFactory,
                                                      overlayColor:
                                                      MaterialStatePropertyAll(
                                                          Color(0xffE9F0FF)),
                                                    ),
                                                    child: ListTile(
                                                      leading: Icon(Icons.delete_forever,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .outline),
                                                      title: Text('Delete profile image',
                                                          style: GoogleFonts.roboto(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 18)),
                                                    ),
                                                  );
                                                }

                                              })
                                            ],
                                          );
                                        });
                                  },
                                  child: Obx(() {
                                    if (_authController.userModel.profilePic == '') {
                                      return CircleAvatar(
                                        // backgroundColor: Theme.of(context).colorScheme.background,
                                          radius: 40,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(40),
                                            child: _authController.imageFile.value == null
                                                ? const CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  'assets/images/pfavatar.png'),
                                            )
                                                : Image.file(_authController.imageFile.value!,
                                                fit: BoxFit.cover),
                                          ));
                                    } else {
                                      return CircleAvatar(
                                          radius: 40,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(40),
                                            child: _authController.imageFile.value == null
                                                ? Image.network(_authController.userModel.profilePic,
                                                fit: BoxFit.cover)
                                                : Image.file(_authController.imageFile.value!,
                                                fit: BoxFit.cover),
                                          ));
                                    }
                                  }),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Profile Data',
                                  style: GoogleFonts.lora(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 40,
                                      color: Colors.black),
                                ),
                                ListTile(
                                  leading: Text(
                                    'Name:',
                                    style: GoogleFonts.lora(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  trailing: Obx(() {
                                    return Text(
                                      _authController.userModel.name,
                                      // _data.name.value,
                                      // 'User Name',
                                      style: GoogleFonts.lora(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    );
                                  }),
                                ),
                                ListTile(
                                  leading: Text(
                                    'Phone Number:',
                                    style: GoogleFonts.lora(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  trailing: Obx(() {
                                    return Text(
                                      _authController.userModel.phone,
                                      // _data.phone.value,
                                      style: GoogleFonts.lora(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    );
                                  }),
                                ),
                                ListTile(
                                  leading: Text(
                                    'City:',
                                    style: GoogleFonts.lora(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  trailing: Obx(() {
                                    return Text(
                                      _authController.userModel.location,
                                      // _data.location.value,
                                      // 'Vehari',
                                      style: GoogleFonts.lora(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ))),
          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  Text(
                    'Created Cometies',
                    style: GoogleFonts.lora(
                        fontWeight: FontWeight.w400,
                        fontSize: 35,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Obx((){
                          return Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    _stateController.profileFilterCometie.value=0;
                                  },
                                  child: FilterButton(title: 'All',txtColor:
                                  _stateController.profileFilterCometie.value==0?
                                  const Color(0xff003CBE):Colors.black)),
                              GestureDetector(
                                  onTap: (){
                                    _stateController.profileFilterCometie.value=1;
                                  },
                                  child: FilterButton(title: 'Pending',txtColor:
                                  _stateController.profileFilterCometie.value==1?
                                  const Color(0xff003CBE):Colors.black)),
                              GestureDetector(
                                  onTap: (){
                                    _stateController.profileFilterCometie.value=2;
                                  },
                                  child: FilterButton(title: 'Progress',txtColor:
                                  _stateController.profileFilterCometie.value==2?
                                  const Color(0xff003CBE):Colors.black)),
                              GestureDetector(
                                  onTap: (){
                                    _stateController.profileFilterCometie.value=3;
                                  },
                                  child: FilterButton(title: 'Completed',txtColor:
                                  _stateController.profileFilterCometie.value==3?
                                  const Color(0xff003CBE):Colors.black))
                            ],
                          );
                        })
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Obx((){
                    return StreamBuilder<QuerySnapshot>(
                      stream: _stateController.profileFilterCometie.value==0?
                      FirebaseFirestore.instance.collection('Cometies')
                          .where('uid', isEqualTo: _authController.uid)
                          .snapshots():_stateController.profileFilterCometie.value==1?
                      FirebaseFirestore.instance.collection('Cometies')
                          .where('uid', isEqualTo: _authController.uid).where('status',isEqualTo: 'Pending')
                          .snapshots():_stateController.profileFilterCometie.value==2?
                      FirebaseFirestore.instance.collection('Cometies')
                          .where('uid', isEqualTo: _authController.uid).where('status',isEqualTo: 'Progress')
                          .snapshots():
                      FirebaseFirestore.instance.collection('Cometies')
                          .where('uid', isEqualTo: _authController.uid).where('status',isEqualTo: 'Completed')
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CometieInfoScreen(
                                        cometieId: cometieData['cometieId'],
                                      )));
                                    },
                                    tileColor: const Color(0xffE9F0FF),
                                    // contentPadding: const EdgeInsets.only(right: 15),
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
                            ),
                          );

                        } else {
                          return const Center(child: Text('Something went wrong!'));
                        }
                      },
                    );
                  })
                ],),
              )),
        ],
      ),
    );
  }
}


class FilterButton extends StatelessWidget {
  final String title;
  final Color txtColor;

  FilterButton({
    super.key,
    required this.title,
    required this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Text(title, style: GoogleFonts.roboto(
          color: txtColor,
          fontWeight: FontWeight.w500,
        ),),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controller/notification_controller.dart';
import '../Controller/state_controller.dart';



class OthersProfileScreen extends StatefulWidget {
  final String id;
  final String cometieIid;
  final String cometieName;
  final String response;
  final String notificationId;
  const OthersProfileScreen({super.key, required this.id,required this.cometieIid,required this.cometieName,required this.response,required this.notificationId});

  @override
  State<OthersProfileScreen> createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> {
  final ScrollController scController = ScrollController();
  final _authController = Get.put(AuthController());
  final _stateController = Get.put(StateController());
  String? _name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();

  }
  getName()async {
    await FirebaseFirestore.instance.collection('Users').doc(widget.id)
        .get()
        .then((snap) {
          setState(() {
            _name=snap.get('name');
          });
    });
  }
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
          _name??'',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').doc(widget.id).snapshots(),
        builder: (context, snapshot) {
          return Column(
            children: [
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
                    CircleAvatar(
                        radius: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: snapshot.data?['profilePic'] != ''
                              ? Image.network(snapshot.data?['profilePic'],
                              fit: BoxFit.cover)
                              : Image.asset('assets/images/pfavatar.png', fit: BoxFit.cover),
                        )),
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
                        trailing: Text(
                          snapshot.data?['name'],
                          // _data.name.value,
                          // 'User Name',
                          style: GoogleFonts.lora(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                    ),
                    ListTile(
                      leading: Text(
                        'Phone Number:',
                        style: GoogleFonts.lora(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      trailing: Text(
                        snapshot.data?['phone'],
                        // _data.phone.value,
                        style: GoogleFonts.lora(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    ListTile(
                        leading: Text(
                          'City:',
                          style: GoogleFonts.lora(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        trailing: Text(
                          snapshot.data?['location'],
                          // _data.location.value,
                          // 'Vehari',
                          style: GoogleFonts.lora(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              widget.response=='pending'?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                            backgroundColor:
                            const WidgetStatePropertyAll(Color(0xff003CBE))),
                        onPressed: () {
                          Notifications().sendAcceptOffer(
                              widget.cometieName,
                              widget.id,
                              widget.cometieIid,
                              widget.notificationId);
                          Navigator.pop(context);
                        },
                        child: FittedBox(
                          child: Text(
                            'Accept',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            side: WidgetStatePropertyAll(BorderSide(color: Color(0xff003CBE),width: 1)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                            backgroundColor:
                            const WidgetStatePropertyAll(Colors.white
                            )
                        ),
                        onPressed: () {
                          Notifications().sendCancelOffer(
                              widget.cometieName,
                              widget.id,
                              widget.cometieIid,
                          widget.notificationId);
                          Navigator.pop(context);

                        },
                        child: FittedBox(
                          child: Text(
                            'Cancel',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) :
                  widget.response=='cancel'?
              Text('Rejected',style: GoogleFonts.alef(
                color: Colors.red,
                fontSize: 20
              ),):
                  Text('Accepted',style: GoogleFonts.alef(
                      color: Colors.green,
                      fontSize: 20
                  ))
            ],
          );
        },
      )
    );
  }
}

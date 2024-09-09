import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/auth_controller.dart';
import 'package:digital_cometie_app/Controller/cometie_controller.dart';
import 'package:digital_cometie_app/Views/report_cometie_info.dart';
import 'package:digital_cometie_app/Widgets/image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/custom_text_form_field.dart';


class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});
  final TextEditingController _dateController = TextEditingController();
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE9F0FF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Reports',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                color: const Color(0xffE9F0FF),
                elevation: 5,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Date',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      ListTile(
                        shape: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 2)),
                        title: Text(
                          'Enter Date',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                              color: Colors.black),
                        ),
                        trailing: const Icon(
                          Icons.date_range,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomTextFormField(
                        controller: _dateController,
                        textType: TextInputType.datetime,
                        hintText: 'mm/dd/yyyy',
                        borderRadius: 4,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'OK',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').doc(_authController.userModel.uid).collection('JoinedCometies').snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snap.data?.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Cometies').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return ListTile(
                              title: Text('Loading...'),
                            );
                          }
                          return Card(
                            color: const Color(0xffE9F0FF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 30,
                            shadowColor: const Color(0xff003CBE),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                if(snap.data?.docs[i]['cometieId']==snapshot.data?.docs[index]['cometieId']){
                                  return ListTile(
                                    tileColor: const Color(0xffE9F0FF),
                                    contentPadding: const EdgeInsets.only(right: 15),
                                    leading: CircleAvatar(
                                      radius: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: ImageBuilder(image: snapshot.data?.docs[index]['creatorProfilePic']),
                                      ),
                                    ),
                                    title: Text(
                                      snapshot.data?.docs[index]['cometieName'],
                                      style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Amount: ${snapshot.data?.docs[index]['eachAmount']}',
                                          style: GoogleFonts.roboto(
                                            // fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '${snapshot.data?.docs[index]['status']}',
                                          style: GoogleFonts.roboto(
                                            // fontSize: 20,
                                              letterSpacing: 2,
                                              fontWeight: FontWeight.w400,
                                              color: snapshot.data?.docs[index]['status']=='Completed'?
                                              const Color(0xff003CBE):
                                              snapshot.data?.docs[index]['status']=='Pending'?
                                              Colors.redAccent:Colors.green
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ReportCometieInfoScreen(
                                                  cometieId: snapshot.data?.docs[index]['cometieId'],
                                                )));
                                      },
                                      icon: SvgPicture.asset('assets/svg/info.svg'),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
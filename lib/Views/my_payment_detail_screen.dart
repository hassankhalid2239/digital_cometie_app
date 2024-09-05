import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/auth_controller.dart';
import 'package:digital_cometie_app/Views/profile/add_payment_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';

import 'my_cometie_info_screen.dart';


class MyPaymentDetailScreen extends StatelessWidget {
  final String memberUid;
  final String cometieId;
  final String creatorId;

   MyPaymentDetailScreen({super.key,required this.memberUid,required this.cometieId, required this.creatorId});
  final _authController= Get.put(AuthController());
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
          'Payment Detail',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Cometies').doc(cometieId).collection('Members').doc(memberUid).collection('Payments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return  ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xffE9F0FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: Colors.black,
                  child: Column(
                    children: [
                      ListTile(
                        leading: InstaImageViewer(
                          child: CircleAvatar(
                          radius: 25,
                            backgroundImage: snapshot.data!.docs[index]['screenshot']==''?
                            const AssetImage('assets/images/pfavatar.png'):
                            NetworkImage(snapshot.data!.docs[index]['screenshot']),
                          ),
                        ),
                        title: Text(
                          snapshot.data!.docs[index].id.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['paymentStatus'],
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: snapshot.data!.docs[index]['paymentStatus']=='Unpaid'?
                              Colors.redAccent:Colors.green
                          ),
                        ),
                        trailing: creatorId != _authController.userModel.uid?
                        snapshot.data!.docs[index]['enable']==true?
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPaymentDetailScreen(
                              cometieId: cometieId,
                              paymentIndex: snapshot.data!.docs[index].id.toString(),
                            )));
                          },
                          icon: const Icon(Icons.edit_outlined,size: 25,),
                        ):
                        SizedBox():
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPaymentDetailScreen(
                              cometieId: cometieId,
                              paymentIndex: snapshot.data!.docs[index].id.toString(),
                            )));
                          },
                          icon: const Icon(Icons.edit_outlined,size: 25,),
                        )
                      ),
                      InfoListTile(title: 'Amount', value: snapshot.data!.docs[index]['amount'].toString()),
                      InfoListTile(title: 'Transaction Id', value: snapshot.data!.docs[index]['transactionId'].toString()),
                      snapshot.data!.docs[index]['screenshot']==''?
                      InfoListTile(title: 'Date', value: 'Pending'):
                      InfoListTile(title: 'Date', value: DateFormat('EEE, d MMM yyyy').format(snapshot.data!.docs[index]['paymentDate'].toDate())),
                    ],
                  ),
                );
              },
            );

          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}

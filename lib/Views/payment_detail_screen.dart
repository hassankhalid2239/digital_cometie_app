import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cometie_info_screen.dart';

class PaymentDetailScreen extends StatelessWidget {
  final String memberUid;
  final String cometieId;
  const PaymentDetailScreen({super.key,required this.memberUid,required this.cometieId});

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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return  ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xffE9F0FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: Colors.black,
                  child: ExpansionTile(
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    iconColor:Colors.black,
                    collapsedIconColor: Colors.black,
                    onExpansionChanged: (value){},
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
                    children: [
                      InfoListTile(title: 'Amount', value: snapshot.data!.docs[index]['amount'].toString()),
                      InfoListTile(title: 'Transaction Id', value: snapshot.data!.docs[index]['transactionId'].toString()),
                      InfoListTile(title: 'Date', value: snapshot.data!.docs[index]['paymentDate'].toString()),

                    ],
                  ),
                );
              },
            );

          } else {
            return Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}

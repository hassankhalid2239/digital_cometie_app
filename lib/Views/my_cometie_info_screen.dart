import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/auth_controller.dart';
import 'package:digital_cometie_app/Views/my_payment_detail_screen.dart';
import 'package:digital_cometie_app/Views/profile/payment_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Controller/cometie_controller.dart';
import '../Widgets/custom_elevated_button.dart';


class MyCometieInfoScreen extends StatelessWidget {
  final String cometieId;
  final _authController=Get.put(AuthController());
  final _cometieController=Get.put(CometieController());
  MyCometieInfoScreen({super.key,required this.cometieId});
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
          'Cometie Detail',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xffE9F0FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              shadowColor: Colors.black,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Cometies')
                    .doc(cometieId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          InfoListTile(title: 'Cometie Name',value: snapshot.data!['cometieName'],),
                          InfoListTile(title: 'Total Amount',value:  snapshot.data!['amount'].toString(),),
                          InfoListTile(title: 'Amount Per Cometie',value:  snapshot.data!['eachAmount'].toString(),),
                          InfoListTile(title: 'Total Months',value:  snapshot.data!['duration'].toString(),),
                          InfoListTile(title: 'Created At',value: DateFormat('EEE, d MMM yyyy').format(snapshot.data!['createdAt'].toDate()),),
                          InfoListTile(title: 'Launched At',value:  DateFormat('EEE, d MMM yyyy').format(snapshot.data!['launchedAt'].toDate()),),
                          DateFormat('EEE, d MMM yyyy').format(snapshot.data!['completedAt'].toDate())==DateFormat('EEE, d MMM yyyy').format(snapshot.data!['createdAt'].toDate())?
                          const InfoListTile(title: 'Due Date',value:  'Pending',):
                          InfoListTile(title: 'Due Date',value:  DateFormat('EEE, d MMM yyyy').format(snapshot.data!['completedAt'].toDate()),),
                        ],
                      ),
                    );
        
                  } else {
                    return const Center(child: Text('Something went wrong!'));
                  }
                },
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('Members',style:GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
              ),),
            ),
            Card(
              color: const Color(0xffE9F0FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              shadowColor: Colors.black,
              child:StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Cometies').doc(cometieId).collection('Members').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            var snap= await FirebaseFirestore.instance.collection('Cometies').doc(cometieId).get();
                            var data= snap.data()!;
                            if(snapshot.data?.docs[index]['memberUid']!=_authController.userModel.uid){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentDetailScreen(
                                memberUid: snapshot.data?.docs[index]['memberUid'],
                                cometieId: cometieId,
                              )
                              ));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPaymentDetailScreen(
                                memberUid: snapshot.data?.docs[index]['memberUid'],
                                creatorId: data['uid'],
                                cometieId: cometieId,
                              )
                              ));
                            }
                          },
                          contentPadding: const EdgeInsets.only(right: 15),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: snapshot.data?.docs[index]['memberProfilePic']==''?
                            const AssetImage('assets/images/pfavatar.png'):
                            NetworkImage(snapshot.data?.docs[index]['memberProfilePic']),
                          ),
                          title: Text(
                            snapshot.data?.docs[index]['memberName'],
                            style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          subtitle: Text(
                            snapshot.data?.docs[index]['memberPhone'],
                            style: GoogleFonts.roboto(
                              // fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,),
                        );
                      },
                    );

                  } else {
                    return const Center(child: Text('Something went wrong!'));
                  }
                },
              )
            )
          ],
        ),
      ),
    );
  }
}

class InfoListTile extends StatelessWidget {
  final String title;
  final String value;
  const InfoListTile({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$title:',style: GoogleFonts.roboto(
        fontSize: 15,
        fontWeight: FontWeight.w500
      ),),
      trailing: Text(value,style: GoogleFonts.roboto(
          fontSize: 15,
          fontWeight: FontWeight.w500
      ),),
    );
  }
}

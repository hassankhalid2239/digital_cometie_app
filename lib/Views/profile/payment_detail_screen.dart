import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import '../../Controller/cometie_controller.dart';
import '../../Controller/notification_controller.dart';
import '../../Widgets/custom_elevated_button.dart';
import '../my_cometie_info_screen.dart';


class PaymentDetailScreen extends StatelessWidget {
  final String memberUid;
  final String cometieId;
  final _cometieController=Get.put(CometieController());
  PaymentDetailScreen({super.key,required this.memberUid,required this.cometieId});

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
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              physics: const NeverScrollableScrollPhysics(),
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
                    leading: InstaImageViewer(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: snapshot.data?.docs[index]['screenshot']==''?
                        const AssetImage('assets/images/pfavatar.png'):
                        NetworkImage(snapshot.data?.docs[index]['screenshot']),
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
                    children: [
                      InfoListTile(title: 'Amount', value: snapshot.data!.docs[index]['amount'].toString()),
                      InfoListTile(title: 'Transaction Id', value: snapshot.data!.docs[index]['transactionId'].toString()),
                      snapshot.data!.docs[index]['screenshot']==''?
                      InfoListTile(title: 'Date', value: 'Pending'):
                      InfoListTile(title: 'Date', value: DateFormat('EEE, d MMM yyyy').format(snapshot.data!.docs[index]['paymentDate'].toDate())),
                      Obx((){
                        if(_cometieController.loading.value==true){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: const Color(0xff003CBE),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white,),
                              ),
                            ),
                          );
                        }else{
                          if(snapshot.data!.docs[index]['paymentStatus']=='Unpaid'){
                            return CustomElevatedButton(
                              title: 'Send ${snapshot.data!.docs[index].id.toString()} Alert',
                              onTap: () {
                                Notifications().sendPaymentAlert(
                                    memberUid,
                                    snapshot.data!.docs[index].id,
                                    cometieId);
                              },
                            );
                          }else{
                            return SizedBox();
                          }

                        }
                      }),
                      SizedBox(height: 8,)
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

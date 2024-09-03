import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Controller/notification_controller.dart';
import 'my_cometie_info_screen.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  final String cometieId;
  final String notificationId;
  final String receiverId;
  final String paymentIndex;
  final String receiverName;
  const ConfirmPaymentScreen({super.key, required this.cometieId, required this.notificationId, required this.receiverId, required this.paymentIndex, required this.receiverName});

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
          'Confirm Payment',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Cometies').doc(cometieId).collection('Members').doc(receiverId).collection('Payments').doc(paymentIndex).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }else if (snapshot.hasData){
                  return Card(
                    color: const Color(0xffE9F0FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: snapshot.data!['screenshot']==''?
                            const AssetImage('assets/images/pfavatar.png'):
                            NetworkImage(snapshot.data!['screenshot']),
                          ),
                          title: Text(
                            paymentIndex.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          subtitle: Text(
                            snapshot.data!['paymentStatus'],
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: snapshot.data!['paymentStatus']=='Unpaid'?
                                Colors.redAccent:Colors.green
                            ),
                          ),
                        ),
                        InfoListTile(title: 'Name', value: receiverName),
                        InfoListTile(title: 'Amount', value: snapshot.data!['amount'].toString()),
                        InfoListTile(title: 'Transaction Id', value: snapshot.data!['transactionId'].toString()),
                        snapshot.data!['screenshot']==''?
                        InfoListTile(title: 'Date', value: 'Pending'):
                        InfoListTile(title: 'Date', value: DateFormat('EEE, d MMM yyyy').format(snapshot.data!['paymentDate'].toDate())),
                        SizedBox(height: 15,),
                        snapshot.data!['paymentConfirmation']=='Pending'?
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
                                    Notifications().sendPaymentConfirm(
                                        paymentIndex,
                                        cometieId,
                                        receiverId);
                                    Navigator.pop(context);
                                  },
                                  child: FittedBox(
                                    child: Text(
                                      'Confirm',
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
                                      side: const WidgetStatePropertyAll(BorderSide(color: Color(0xff003CBE),width: 1)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25))),
                                      backgroundColor:
                                      const WidgetStatePropertyAll(Colors.white
                                      )
                                  ),
                                  onPressed: () {
                                    Notifications().sendPaymentCancelConfirm(
                                        cometieId,
                                        paymentIndex,
                                        receiverId);
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
                        snapshot.data!['paymentConfirmation']=='NotConfirmed'?
                        Text('Canceled',style: GoogleFonts.alef(
                            color: Colors.red,
                            fontSize: 20
                        ),):
                        Text('Confirmed',style: GoogleFonts.alef(
                            color: Colors.green,
                            fontSize: 20
                        )),
                        SizedBox(height: 10,)
                      ],
                    ),
                  );
                }else{
                  return Center(
                    child: Text('Something went wrong',
                        style: Theme.of(context).textTheme.labelMedium),
                  );
                }

              },
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Controller/cometie_controller.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import '../Widgets/custom_text_form_field.dart';


class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});
  final _stateController = Get.put(StateController());
  final TextEditingController _dateController = TextEditingController();

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
              StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                stream: CometieController().getCometiesReport(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No cometies found.'));
                  }
                  var cometies = snapshot.data!;
                  return Card(
                    color: const Color(0xffE9F0FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 30,
                    shadowColor: const Color(0xff003CBE),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cometies.length,
                      itemBuilder: (context, index) {
                        var cometie = cometies[index].data();
                        // Display cometie data here
                        return ListTile(
                          tileColor: const Color(0xffE9F0FF),
                          contentPadding: const EdgeInsets.only(right: 15),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: cometie?['creatorProfilePic']==''?
                            AssetImage('assets/images/pfavatar.png'):
                            NetworkImage(cometie?['creatorProfilePic']),
                          ),
                          title: Text(
                            cometie?['cometieName'],
                            style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount: ${cometie?['eachAmount']}',
                                style: GoogleFonts.roboto(
                                  // fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                '${cometie?['status']}',
                                style: GoogleFonts.roboto(
                                  // fontSize: 20,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w400,
                                    color: cometie?['status']=='Completed'?
                                    Color(0xff003CBE):
                                    cometie?['status']=='Pending'?
                                    Colors.redAccent:Colors.green
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const CometieInfoScreen()));
                            },
                            icon: SvgPicture.asset('assets/svg/info.svg'),
                          ),
                        );
                      },
                    ),
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
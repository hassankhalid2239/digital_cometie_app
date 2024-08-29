import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/custom_text_form_field.dart';


class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

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
              Card(
                color: const Color(0xffE9F0FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 30,
                shadowColor: const Color(0xff003CBE),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      height: 1,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
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
                            //         builder: (context) => const CometieInfoScreen()));
                          },
                          icon: SvgPicture.asset('assets/svg/info.svg'),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

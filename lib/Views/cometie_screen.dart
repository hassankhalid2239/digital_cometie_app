import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/custom_elevated_button.dart';


class CometieScreen extends StatelessWidget {
  const CometieScreen({super.key});

  Future<void> refreshData() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE9F0FF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Cometies',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: const Color(0xff003CBE),
        backgroundColor: const Color(0xffE9F0FF),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        child: CustomElevatedButton(
                          title: 'All',
                          onTap: () {},
                          bgColor: const Color(0xffE9F0FF),
                          titleColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        child: CustomElevatedButton(
                          title: 'Month',
                          onTap: () {},
                          bgColor: const Color(0xffE9F0FF),
                          titleColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        child: CustomElevatedButton(
                          title: 'Location',
                          onTap: () {},
                          bgColor: const Color(0xffE9F0FF),
                          titleColor: Colors.black,
                        ),
                      ),
                    ],
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
                              //         builder: (context) => CometieInfoScreen()));
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
      ),
    );
  }
}

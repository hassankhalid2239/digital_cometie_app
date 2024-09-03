import 'package:digital_cometie_app/Controller/cometie_controller.dart';
import 'package:digital_cometie_app/Controller/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/custom_elevated_button.dart';
import 'others_cometie_info_screen.dart';


class CometieScreen extends StatelessWidget {
   CometieScreen({super.key});

  final _stateController=Get.put(StateController());
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
                      Obx((){
                        return CustomElevatedButton(
                            title: 'All',
                            onTap: () {
                              _stateController.cometieFilterIndex.value=0;
                            },
                            bgColor: const Color(0xffE9F0FF),
                            titleColor: Colors.black,
                            borderColor: _stateController.cometieFilterIndex.value==0?
                            const Color(0xff003CBE):Colors.transparent
                        );
                      }),
                      const SizedBox(
                        width: 15,
                      ),
                      Obx((){
                        return CustomElevatedButton(
                            title: 'Month',
                            onTap: () {
                              _stateController.cometieFilterIndex.value=1;
                            },
                            bgColor: const Color(0xffE9F0FF),
                            titleColor: Colors.black,
                            borderColor: _stateController.cometieFilterIndex.value==1?
                            const Color(0xff003CBE):Colors.transparent
                        );
                      }),
                      const SizedBox(
                        width: 15,
                      ),
                      Obx((){
                        return  CustomElevatedButton(
                            title: 'Location',
                            onTap: () {
                              _stateController.cometieFilterIndex.value=2;
                            },
                            bgColor: const Color(0xffE9F0FF),
                            titleColor: Colors.black,
                            borderColor: _stateController.cometieFilterIndex.value==2?
                            const Color(0xff003CBE):Colors.transparent
                        );
                      })

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
                    child: Obx((){
                      return StreamBuilder(
                        stream: CometieController().getCometies(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(),);
                          } else if (snapshot.connectionState == ConnectionState.active) {
                            if (snapshot.data?.docs.isNotEmpty == true) {
                              return ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  height: 1,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    tileColor: const Color(0xffE9F0FF),
                                    contentPadding: const EdgeInsets.only(right: 15),
                                    leading: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: snapshot.data?.docs[index]['creatorProfilePic']==''?
                                      const AssetImage('assets/images/pfavatar.png'):
                                      NetworkImage(snapshot.data?.docs[index]['creatorProfilePic']),
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
                                          'Amount: ${snapshot.data?.docs[index]['amount']}',
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
                                              const Color(0xff003CBE):Colors.green
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OthersCometieInfoScreen(cometieId:  snapshot.data?.docs[index]['cometieId'],)));
                                      },
                                      icon: SvgPicture.asset('assets/svg/info.svg'),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text('There is no Cometies!',
                                    style: Theme.of(context).textTheme.labelMedium),
                              );
                            }
                          }
                          return Center(
                            child: Text('Something went wrong',
                                style: Theme.of(context).textTheme.labelMedium),
                          );
                        },
                      );
                    })
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


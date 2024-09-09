import 'package:digital_cometie_app/Views/profile/profile_screen.dart';
import 'package:digital_cometie_app/Views/report_screen.dart';
import 'package:digital_cometie_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../Controller/auth_controller.dart';
import '../Controller/state_controller.dart';
import 'cometie_screen.dart';
import 'create_cometie/create_screen.dart';
import 'home_screen.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _stateController = Get.put(StateController());
  final _authController = Get.put(AuthController());

  whenPageChanges(int pageIndex) {
    _stateController.getPageIndex.value = pageIndex;
  }

  onTapChange(int pageIndex) {
    _stateController.pageController.value.animateToPage(pageIndex,
        duration: const Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController.getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: _stateController.getPageIndex.value,
          children: [
            const HomeScreen(),
            CometieScreen(),
            const SizedBox(),
            ReportScreen(),
            const ProfileScreen(),
          ],
        );
      }),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              // height: context.h*0.099,
              height: 80,
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(context.r(0.0261)),
                      // topLeft: Radius.circular(10),
                      topRight: Radius.circular(context.r(0.0261))),
                      // topRight: Radius.circular(10)),
                  color: Color(0xff003CBE),
                  image: DecorationImage(
                      image: AssetImage('assets/images/btm.png'),
                      fit: BoxFit.fill))),
          Obx(() {
            return CupertinoTabBar(
              currentIndex: _stateController.getPageIndex.value,
              onTap: (value) {
                if (value != 2) {
                  _stateController.getPageIndex.value = value;
                }
              },
              backgroundColor: const Color(0xffE9F0FF),
              activeColor: const Color(0xff386BF6),
              border: Border.all(width: 0, color: Colors.transparent),
              inactiveColor: Colors.grey,
              iconSize: context.r(0.066),
              // iconSize: 25,
              // height: context.h*0.062,
              height: 50,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/home_outline.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/svg/home_primary.svg',
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/cometie_outline.svg',
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/svg/cometie_primary.svg',
                    // height: context.h*0.035,
                    height: 28,
                  ),
                  label: 'Cometie',
                ),
                const BottomNavigationBarItem(
                    icon: Opacity(
                        opacity: 0,
                        child: Icon(
                          Icons.add,
                        ))),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/report_outline.svg',
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/svg/report_primary.svg',
                  ),
                  label: 'Report',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/profile_outline.svg',
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/svg/profile_primary.svg',
                  ),
                  label: 'Profile',
                )
              ],
            );
          }),
          Positioned(
            // bottom: context.h*0.013,
            bottom: 10,
            child: SizedBox(
              // height: context.h*0.0735,
              height: 60,
              width: context.w*0.157,
              // width: 60,
              child: FittedBox(
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xff003CBE),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateScreen()));
                  },
                  child: SvgPicture.asset(
                    'assets/svg/add.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

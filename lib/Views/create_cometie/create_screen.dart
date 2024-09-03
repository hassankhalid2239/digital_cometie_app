import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/auth_controller.dart';
import '../../Controller/cometie_controller.dart';
import '../../Controller/state_controller.dart';
import '../../Widgets/custom_elevated_button.dart';
import '../../Widgets/custom_text_form_field.dart';
import 'add_member_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _cometieNameController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  final _stateController = Get.put(StateController());
  final TextEditingController _searchController = TextEditingController();
  final _cometieController= Get.put(CometieController());
  final _authController= Get.put(AuthController());


  String searchQuery = 'Search query';
  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _updateSearchQuery('');
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

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
          'Create',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            const Image(
              height: 200,
              image: AssetImage('assets/images/create.png'),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: double.infinity,
              // height: 480,
              child: Card(
                elevation: 20,
                color: const Color(0xffE9F0FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cometie Name',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _cometieNameController,
                        hintText: 'Cometie Name',
                        fieldPadding: 0,
                        hintSize: 14,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Add Amount',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _amountController,
                        hintText: 'Enter Total Ammount',
                        fieldPadding: 0,
                        hintSize: 14,
                        textType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Duration',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black,width: 1),
                          color: Colors.transparent
                        ),
                        child: Obx((){
                          return Text(_stateController.currentValue.round().toString(),style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 15,
                          ),);
                        })
                      ),
                      Obx((){
                        return Slider(
                          value: _stateController.currentValue.value,
                          max: 12,
                          activeColor: Color(0xff003CBE),
                          min: 0,
                          divisions: 12,
                          onChangeStart: (value) {
                            _stateController.note.value=true;
                          },
                          label: _stateController.currentValue.value.round().toString(),
                          onChanged: (value){
                            _stateController.currentValue.value=value;
                          },
                        );
                      }),
                      Obx((){
                        if(_stateController.note.value==true){
                          return Text('Note: Duration and Members should be same!',style: GoogleFonts.alef(
                              color: Colors.redAccent
                          ),);
                        }else{
                          return SizedBox();
                        }
                      }),
                      const SizedBox(
                        height: 25,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: CustomElevatedButton(
                              title: 'Next', onTap: () {

                                if(_amountController.text.isNotEmpty && _cometieNameController.text.isNotEmpty){
                                  _cometieController.members.add(
                                      {
                                        'memberUid':_authController.userModel.uid,
                                        'memberName':_authController.userModel.name,
                                        'memberPhone':_authController.userModel.phone,
                                        'memberProfilePic':_authController.userModel.profilePic,
                                      }
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMemberScreen(
                                    name: _cometieNameController.text,
                                    amount: _amountController.text.trim(),
                                  )));
                                  _stateController.note.value=false;
                                }else{
                                  Get.snackbar(
                                    'Required',
                                    'Field should not be empty!',
                                    backgroundColor: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 1),
                                    icon: const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                    ),
                                    colorText: Colors.pinkAccent,
                                  );
                                }
                          }))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget makeDismissible(
      {required Widget child, required BuildContext context}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}

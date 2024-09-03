import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/cometie_controller.dart';
import '../../Controller/state_controller.dart';
import '../../Widgets/custom_elevated_button.dart';
import '../main_page.dart';

class AddMemberScreen extends StatefulWidget {
  final String name;
  final String amount;
  const AddMemberScreen({super.key,required this.name,required this.amount});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _cometieController= Get.put(CometieController());

  final _stateController= Get.put(StateController());

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
          'Select Members',
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          _cometieController.members.clear();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Select Members',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 100,
              child: Obx((){
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _cometieController.members.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 90,
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                          radius: 25,
                        backgroundImage: _cometieController.members[index]['memberProfilePic']==''?
                        const AssetImage('assets/images/pfavatar.png'):
                        NetworkImage(_cometieController.members[index]['memberProfilePic']),
                      ),),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                _cometieController.members.removeAt(index);
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              _cometieController.members[index]['memberName'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              })
            ),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Search People',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                autocorrect: true,
                controller: _searchController,
                keyboardType: TextInputType.text,
                style: GoogleFonts.alef(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 25,
                ),
                onChanged: (query) => _updateSearchQuery(query),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      _clearSearchQuery();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.black, style: BorderStyle.solid, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.black, width: 2, style: BorderStyle.solid)),
                  hintText: 'Search User',
                  hintStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff91919F),
                    fontSize: 25,
                  ),
                ),
                cursorColor: const Color(0xff00A86B),
            ),),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Users').where('name',isEqualTo: searchQuery)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data.docs.isNotEmpty == true) {
                      return  Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                bool isAlreadyAdded = _cometieController.members
                                    .any((member) =>
                                member['memberUid'] ==
                                    snapshot.data.docs[index]['uid']);
                                if(isAlreadyAdded){
                                  Utils().showToastMessage('User Already Added');
                                }else if(_cometieController.members.length==_stateController.currentValue.round()){
                                  Utils().showToastMessage('Only ${_stateController.currentValue.round()} members allowed!');
                                }
                                else{
                                  _cometieController.members.add(
                                      {
                                        'memberUid':snapshot.data.docs[index]['uid'],
                                        'memberName':snapshot.data.docs[index]['name'],
                                        'memberPhone':snapshot.data.docs[index]['phone'],
                                        'memberProfilePic':snapshot.data.docs[index]['profilePic'],
                                      }
                                  );
                                }
                              },
                              contentPadding: const EdgeInsets.only(right: 15),
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage: snapshot.data.docs[index]['profilePic']==''?
                                const AssetImage('assets/images/pfavatar.png'):
                                NetworkImage(snapshot.data.docs[index]['profilePic']),
                              ),
                              title: Text(
                                snapshot.data.docs[index]['name'],
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              subtitle: Text(
                                snapshot.data.docs[index]['phone'],
                                style: GoogleFonts.roboto(
                                  // fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'There is no users',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      );
                    }
                  }
                  return Center(
                    child: Text('Something went wrong!',
                        style: Theme.of(context).textTheme.labelMedium),
                  );
                },
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.white,
        child:Obx((){
          if(_cometieController.loading.value==true){
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xff003CBE),
                  borderRadius: BorderRadius.circular(25)
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white,),
              ),
            );
          }else{
            return CustomElevatedButton(
              title: 'Create',
              onTap: () {
                _cometieController.storeCometieData(
                    name: widget.name,
                    amount: int.parse(widget.amount),
                    duration: _stateController.currentValue.round(),
                    status: _stateController.currentValue.value.round()==_cometieController.members.length?'Progress':'Pending'
                );
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>  MainPage()),
                        (route) => false);
              },
            );
          }
        })
      ),
    );
  }
}

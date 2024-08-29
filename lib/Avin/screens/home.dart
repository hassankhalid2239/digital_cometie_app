import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/notification_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final NotificationServices _notificationServices=NotificationServices();
  final List<String> _selectedUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationServices.requestNotificationPermission();
    _notificationServices.getDeviceToken().then((token)=>print('ToKen:${token.toString()}'));
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(FirebaseAuth.instance.currentUser!.email.toString(),style: const TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Notification Title'),
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Notification Body'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final userData = user.data() as Map<String, dynamic>?;

                      // Safely get the fcmToken and handle missing field
                      final token = userData != null && userData.containsKey('token')
                          ? userData['token']
                          : null; // Handle missing field

                      if (token == null) {
                        // Skip this student if fcmToken is not available
                        return const SizedBox.shrink();
                      }
                        return CheckboxListTile(
                          title: Text(
                            userData != null && userData.containsKey('email') && userData['email'] != null
                                ? userData['email']
                                : 'Unknown', // Provide a fallback value if 'name' is missing or null
                          ),
                          value: token != null && _selectedUsers.contains(token),
                          onChanged: (selected) {
                            if (token != null) { // Ensure fcmToken is not null before modifying the list
                              setState(() {
                                if (selected!) {
                                  _selectedUsers.add(token);
                                } else {
                                  _selectedUsers.remove(token);
                                }
                              });
                            }
                          },
                        );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue)
              ),
              onPressed: (){
                _notificationServices.sendNotificationToSelectedStudents(
                  _titleController.text.toString(),
                  _bodyController.text.toString(),
                  _selectedUsers
                );
                if(_titleController.text!='' && _bodyController.text !=''){
                  NotificationServices().sendNotificationToSelectedStudents(
                    _titleController.text,
                    _bodyController.text,
                      _selectedUsers
                  );
                  _selectedUsers.clear();
                }else{
                  Fluttertoast.showToast(
                    msg: 'Please enter title, body, and select students.',
                  );
                }
              },
              child: const Text('Send Notification',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

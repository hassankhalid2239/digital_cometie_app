

import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final String title ;
  final String body ;
  const MessageScreen({super.key , required this.title,required this.body});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Message Screen')  ,
      ),
      body: ListTile(
        title: Text(widget.title.toString()),
        subtitle: Text(widget.body.toString()),
      ),
    );
  }
}
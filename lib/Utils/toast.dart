import 'package:fluttertoast/fluttertoast.dart';

class Toast{
  void showToastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
    );
  }
}
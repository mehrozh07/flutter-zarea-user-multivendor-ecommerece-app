import 'package:flutter/material.dart';


void changeScreen(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

// request here
void changeScreenReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
}
// void changeReplacementScreenNamed(BuildContext context, Widget widget){
//
//   Navigator.pushReplacementNamed(context, widget.id);
// }
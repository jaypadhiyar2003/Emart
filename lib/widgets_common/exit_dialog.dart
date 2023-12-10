import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:flutter/services.dart';

Widget exitdialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
        Divider(),
        10.heightBox,
        "Are you sure you want to exit ?".text.color(darkFontGrey).size(16).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(color: redColor,onPress: (){
              SystemNavigator.pop();
            },textColor: Colors.blue,title: "Yes"),
            ourButton(color: redColor,onPress: (){
              Navigator.pop(context);
            },textColor: Colors.blue,title: "No"),
          ],
        )
      ],
    ).box.roundedSM.color(lightGrey).padding(const EdgeInsets.all(12)).make(),
  );
}
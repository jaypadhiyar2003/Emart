import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/widgets_common/loadingIndicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../widgets_common/our_button.dart';

class CartScreen extends StatelessWidget{
  const CartScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
     appBar: AppBar(
       automaticallyImplyLeading: false,
       title: "Shopping Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
     ),
      body: StreamBuilder(
        stream: FirestorServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
           return Container(
             color: Colors.white,
             child: "Cart is empty! 🛒".text.size(18).color(darkFontGrey).fontFamily(semibold).makeCentered(),
           );
          }
          else{
            var data = snapshot.data!.docs;
            controller.calculate(data);
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child: ListView.builder(
                      itemCount: data.length,
                        itemBuilder: (BuildContext context ,int index){
                        return ListTile(
                          leading: Image.network('${data[index]['img']}'),
                          title: "${data[index]['title']}    (x${data[index]['qty']}) ".text.fontFamily(semibold).size(16).make(),
                          subtitle: "${data[index]['tprice']}".numCurrency.text.fontFamily(semibold).color(redColor).size(14).make(),
                          trailing: const Icon(Icons.delete,color: redColor).onTap(() {
                            FirestorServices.deleteDocument(data[index].id);
                          }),
                        );
                        }
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price : ".text.fontFamily(semibold).color(darkFontGrey).make(),
                        Obx(() => "${controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor).make())
                      ],
                    ).box.padding(EdgeInsets.all(12)).width(context.screenWidth - 60).color(lightGolden).roundedSM.make(),
                    10.heightBox,
                    SizedBox(
                        width: context.screenWidth - 60,
                        child: ourButton(
                          color: redColor,
                          onPress: (){},
                          textColor: whiteColor,
                          title: "Proceed to Shipping",
                        ))
                  ],
                ),
              );
          }
        },
      )
    );
  }

}

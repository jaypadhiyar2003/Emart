import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/lists.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/auth_screen/login_screen.dart';
import 'package:emart_app/views/home_screen/components/edit_profile_screen.dart';
import 'package:emart_app/views/profile_screen/components/details_card.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestorServices.getUser(currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor),),);
            }
            else{
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child:Column(
                  children: [
                    //edit profile
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Align(alignment: Alignment.topRight, child: Icon(Icons.edit,color: whiteColor)).onTap(() {
                        controller.nameController.text = data['name'];
                        Get.to(()=> EditProfileScreen(data: data));
                      }),
                    ),
                    // user detail section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == '' ? Image.asset(imgProfile2,width: 100,fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(data['imageUrl'],width: 100,fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make(),
                          5.widthBox,
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "${data['name']}".text.fontFamily(semibold).white.make(),
                                  "${data['email']}".text.white.make(),
                                ],
                              )),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: whiteColor,)),
                              onPressed: () async{
                                await Get.put(AuthController()).signoutMethod(context);
                                Get.offAll(() => const LoginScreen());
                              },
                              child: logOut.text.color(whiteColor).fontFamily(semibold).make()
                          )
                        ],
                      ),
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        detailsCard(count: data['cart_count'],title: "in your cart",width: context.screenWidth/3.4),
                        detailsCard(count: data['wishlist_count'],title: "in your wishlist",width: context.screenWidth/3.4),
                        detailsCard(count: data['order_count'],title: "your orders",width: context.screenWidth/3.4),
                      ],
                    ),
                    //button section
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: profileButtonList.length,
                      itemBuilder: (BuildContext,index){
                        return ListTile(
                          leading: Image.asset(profileButtonIcon[index],width: 22,),
                          title: profileButtonList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(color: lightGrey);
                      },
                    ).box.white.rounded.margin(const EdgeInsets.all(12)).padding(const EdgeInsets.symmetric(horizontal: 16,vertical: 10)).shadowSm.make().box.padding(const EdgeInsets.symmetric(vertical: 20,horizontal: 16)).color(redColor).make(),
                  ],
                ),
              );
            }
            },
        )
      )
    );
  }

}
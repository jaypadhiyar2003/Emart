import 'dart:io';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/widgets_common/applogo_widget.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/custom_textfileld.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EditProfileScreen extends StatelessWidget{
  final dynamic data;
  const EditProfileScreen({Key? key,this.data}) : super (key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<ProfileController>();
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Obx(()=> SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //if data image url and controller is empty
                data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                    ? Image.asset(imgProfile2,width: 100,fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()
                    : //if data image url is not empty but controller path is empty
                data['imageUrl'] != '' && controller.profileImgPath.isEmpty ? Image.network(data['imageUrl'],width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                    : //if both are empty
                Image.file(File(controller.profileImgPath.value),width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make(),

                10.heightBox,
                ourButton(color: redColor,onPress: (){
                  controller.changeImage(context);
                },textColor: whiteColor,title: "Change"),
                Divider(),
                20.heightBox,
                customTextField(hint: nameHint,title: name,isPass: false,controller: controller.nameController),
                10.heightBox,
                customTextField(hint: passwordHint,title: oldpass,isPass: true,controller: controller.oldPassController),
                10.heightBox,
                customTextField(hint: passwordHint,title: newpass,isPass: true,controller: controller.newPassController),
                20.heightBox,
               controller.isLoading.value ? const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(redColor),)
                   : SizedBox(width: context.screenWidth - 60,
                   child: ourButton(color: redColor,onPress: () async{
                      controller.isLoading(true);
                      //if img is not selected
                      if(controller.profileImgPath.value.isNotEmpty){
                        await controller.uploadProfileImage();
                      }else{
                        controller.profileImageLink = data['imageUrl'];
                      }
                      //if old password match with database
                      if(data['password'] == controller.oldPassController.text){
                        await controller.changeAuthPassword(data['email'],controller.oldPassController.text, controller.newPassController.text);
                        await controller.updateProfile(imgUrl: controller.profileImageLink, name: controller.nameController.text, password: controller.newPassController.text);
                        VxToast.show(context, msg: "Upadated");
                      }else{
                        VxToast.show(context, msg: "Wrong Old Password ");
                        controller.isLoading(false);
                      }
                    },title: "Save",textColor: whiteColor)
                )
              ],
            ).box.white.shadowSm.padding(const EdgeInsets.all(16)).margin(const EdgeInsets.only(top: 50,left: 12,right: 12)).rounded.make(),
        ),
        ),
      )
    );
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../main.dart';
import 'my_account_tab.dart';

class EditProfilePage extends StatelessWidget {
  ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.requestFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding * 5),
                buildProfileImageWidget(),
                const SizedBox(height: defaultPadding * 1),
                Center(child: buildPhoneNumber()),
                const SizedBox(height: defaultPadding * 2),
                TextFormField(
                  controller: controller.nameController,
                  decoration: textFieldDecoration('Name'),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                const SizedBox(height: defaultPadding * 1),
                TextFormField(
                  controller: controller.emailController,
                  decoration: textFieldDecoration('EMail'),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 500,
                ),
                const SizedBox(height: defaultPadding * 1),
                getCommonExpandedButton(
                    "Submit", controller.updateProfileAction),
                const SizedBox(height: defaultPadding * 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhoneNumber() => Text(
        currentUserDetails?.phoneNo ?? "",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      );

  Widget buildProfileImageWidget() {
    return Obx(() {
      var user = controller.userDetails.value;
      var isRemote = false;
      var imagePath = controller.image.value.path;
      if (imagePath.isEmpty) {
        if (user.photoUrls.isNotEmpty == true) {
          imagePath = user.photoUrls[0];
          isRemote = true;
        }
      }

      return ProfileImageWidget(
        imagePath: imagePath,
        overlayText: controller.userDetails.value.name,
        isEdit: true,
        isRemote: isRemote,
        onEditClicked: () {
          selectImage(controller.image);
        },
      );
    });
  }
}

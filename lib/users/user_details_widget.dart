import 'package:eq_app/users/user_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../FirebaseManager/UserManager.dart';
import '../common/AppTheme.dart';
import '../common/CommonWidgets.dart';
import '../common/DataClasses.dart';
import 'add_user_details.dart';

class UserDetailsWidget extends StatelessWidget {
  late UserDetails userDetails;
  UserDetailsWidget(this.userDetails);
  UserDetailsController controller = Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return commonScaffold(userDetails.name, _getBody());
  }

  _getBody() {
    return SingleChildScrollView(
      child: Container(
        // padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            children: [
              getCommonLabelWidget(userDetails.name, 'Name'),
              getCommonLabelWidget(userDetails.userRole, 'Role'),
              getCommonLabelWidget(userDetails.phoneNo, 'Mobile'),
              getCommonLabelWidget(userDetails.emailId, 'Email'),
              getCommonExpandedButton('Edit Details', () {
                Get.to(() => AddEditUserScreen(userDetails));
              }),
              TextButton(
                onPressed: deleteButtonAction,
                child: Text('Delete User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteButtonAction() {
    Get.defaultDialog(
      textCancel: "NO",
      textConfirm: "YES",
      title: "Delete User",
      content: Text(
        "Are you sure you want to delete this user?",
        style: AppTextStyles().kTextStyleWithFont,
      ),
      onCancel: () {},
      onConfirm: () {
        controller.deleteAction(userDetails);
      },
    );
  }
}

class UserDetailsController extends GetxController {
  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> deleteAction(UserDetails details) async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          var saved = await deleteUserDetails(details.firestoreId);
          if (saved) {
            UserListController listController = Get.find();
            listController.getUsers();
            Get.back();
            Get.back();
          } else {
            showCustomSnackBar('Failed', 'Failed to Delete details');
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }
}

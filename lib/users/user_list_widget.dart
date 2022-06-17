import 'package:eq_app/users/user_details_widget.dart';
import 'package:eq_app/users/user_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../FirebaseManager/UserManager.dart';
import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../common/DataClasses.dart';
import '../main.dart';
import 'add_user_details.dart';

class UserListWidget extends StatelessWidget {
  UserListController controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    var floatingAction = _getFloatingActionButton();
    return commonScaffold('Users', _cateFutureListData(), floatingAction);
  }

  _cateFutureListData() {
    return Obx(() {
      var items = controller.users.value;
      if (items.isNotEmpty) {
        return _createListData(items);
      } else if (controller.isLoading.value) {
        return getCommonProgressWidget();
      } else {
        return getNoDataWidget();
      }
    });
  }

  _createListData(List<UserDetails> items) {
    return Scrollbar(
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: UserItemWidget(items[index]),
              onTap: () {
                Get.to(() => UserDetailsWidget(items[index]));
              },
            );
          },
        ),
      ),
    );
  }

  _getFloatingActionButton() {
    var userRole = currentUserDetails?.userRole ?? "";
    if (userRole != UserRoles.superAdmin.toString()) {
      return null;
    }
    return FloatingAddIconButton(addAction);
  }

  void addAction() {
    Get.to(() => AddEditUserScreen(UserDetails()));
  }
}

class UserListController extends GetxController {
  var users = <UserDetails>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  @override
  void onClose() {
    users.close();
    isLoading.close();
    super.onClose();
  }

  Future<void> getUsers() async {
    isLoading.value = true;
    users.value = await getAllUserList();
    isLoading.value = false;
  }
}

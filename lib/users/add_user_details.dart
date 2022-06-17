import 'package:eq_app/users/user_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../FirebaseManager/UserManager.dart';
import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../common/DataClasses.dart';

class AddEditUserScreen extends StatelessWidget {
  late UserDetails userDetails;
  AddEditUserController controller = Get.put(AddEditUserController());

  AddEditUserScreen(this.userDetails);

  @override
  Widget build(BuildContext context) {
    _updateControllers();
    return Scaffold(
      appBar: AppBar(
          title: Text(userDetails.name.isEmpty ? 'Add User' : 'Update User')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.requestFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding * 1),
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
                TextFormField(
                  controller: controller.mobileController,
                  decoration: textFieldDecoration('Mobile'),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                const SizedBox(height: defaultPadding * 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Role'),
                    _getRoleDropDown(),
                  ],
                ),
                const SizedBox(height: defaultPadding * 1),
                getCommonExpandedButton("Submit", controller.saveAction),
                const SizedBox(height: defaultPadding * 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateControllers() {
    controller.userDetails = userDetails;
    controller.nameController.text = userDetails.name;
    controller.emailController.text = userDetails.emailId;
    controller.mobileController.text = userDetails.phoneNo;
    controller.selectedRole.value = userDetails.userRole;
  }

  _getRoleDropDown() {
    return Obx(() {
      if (controller.roles.isEmpty) return getCommonProgressWidget();

      if (controller.selectedRole.value.isEmpty)
        controller.selectedRole.value = controller.roles[0];

      return DropdownButton(
        hint: Text(
          'Role',
        ),
        onChanged: (newValue) {
          controller.selectedRole.value = newValue as String;
        },
        value: controller.selectedRole.value,
        items: controller.roles.map((String item) {
          return DropdownMenuItem(
            child: new Text(
              item,
            ),
            value: item,
          );
        }).toList(),
      );
    });
  }
}

class AddEditUserController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  var roles = <String>[].obs;
  var selectedRole = "".obs;

  var userDetails = UserDetails();

  @override
  void onInit() {
    super.onInit();
    _getList();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    roles.close();
    selectedRole.close();
    super.onClose();
  }

  _getList() async {
    roles.value = [
      UserRoles.userManager.toString(),
      UserRoles.userAdmin.toString(),
      UserRoles.serviceEngineer.toString(),
      UserRoles.serviceAdmin.toString()
    ];
  }

  String? validator(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'Please this field must be filled';
    }
    return null;
  }

  Future<void> saveAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            var details = userDetails;
            details.name = nameController.text;
            details.emailId = emailController.text;
            details.phoneNo = mobileController.text;
            details.userRole = selectedRole.value;
            var submitted = await updateUserDetails(details);
            if (submitted) {
              UserListController listController = Get.find();
              listController.getUsers();
              Get.back();
            } else {
              showCustomSnackBar('Failed', 'Failed to Add/Update details');
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }
}

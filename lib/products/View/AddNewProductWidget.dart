import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../FirebaseManager/UserManager.dart';
import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../../common/DataClasses.dart';
import '../../common/globalFunctions.dart';
import '../Controller/AddProductController.dart';

class AddNewProductWidget extends StatelessWidget {
  AddProductController controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    _getList();
    return Scaffold(
      appBar: AppBar(title: Text('Add Equipment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Form(
            key: controller.requestFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding * 2),
                TextFormField(
                  controller: controller.nameController,
                  decoration: textFieldDecoration(CMachineName),
                  validator: emptyCheckValidator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                const SizedBox(height: defaultPadding * 1),
                TextFormField(
                  controller: controller.serialNoController,
                  decoration: textFieldDecoration(CSerialNo),
                  validator: emptyCheckValidator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                const SizedBox(height: defaultPadding * 1),
                TextFormField(
                  controller: controller.modelController,
                  decoration: textFieldDecoration(CModelNo),
                  validator: emptyCheckValidator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                const SizedBox(height: defaultPadding * 1),
                getCommonDateSelectionPicker(
                    controller.purchaseDateWrapper, CPurchasedDate, true),
                const SizedBox(height: defaultPadding * 1.5),
                getCommonNumberInputFieldWidget(CWarrantyPeriodYears,
                    controller.warrantyPeriodController, emptyCheckValidator),
                const SizedBox(height: defaultPadding * 1),
                _getAddAndPreviewImageWidget(),
                const SizedBox(height: defaultPadding * 1),
                TextFormField(
                  controller: controller.detailsController,
                  decoration: textFieldDecoration(CEquipmentDetails),
                  validator: emptyCheckValidator,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 250,
                ),
                const SizedBox(height: defaultPadding * 1),
                TextFormField(
                  controller: controller.addressController,
                  decoration: textFieldDecoration(CAddress),
                  validator: emptyCheckValidator,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 250,
                ),
                const SizedBox(height: defaultPadding * 1),
                if (isNotAppleTester())
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(CAssignedUser),
                      _getServiceManagerDropDown(),
                    ],
                  ),
                // if (isNotAppleTester())
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Text(CUserAdmin),
                //       _getUserAdminDropDown(),
                //     ],
                //   ),
                const SizedBox(height: defaultPadding * 1),
                _getHasPeriodicMaintenanceOrNotSelectionWidget(),
                const SizedBox(height: defaultPadding * 1),
                _getPeriodicMantenancceDetailsWidget(),
                const SizedBox(height: defaultPadding * 1),
                getCommonSaveAndCancelButtons("Save", controller.saveAction),
                const SizedBox(height: defaultPadding * 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getList() async {
    var managerUsers = await getUserList(UserRoles.userManager);
    var adminUsers = await getUserList(UserRoles.userAdmin);
    adminUsers.addAll(managerUsers);
    controller.managerUsers.value = adminUsers;
    controller.adminUsers.value = adminUsers;
  }

  _getServiceManagerDropDown() {
    return Obx(() {
      if (controller.managerUsers.isEmpty) return getCommonProgressWidget();

      if (controller.selectedUserManager.value.uuid == null)
        controller.selectedUserManager.value = controller.managerUsers[0];

      return DropdownButton(
        hint: Text(
          'Select User Manager',
        ),
        onChanged: (newValue) {
          controller.changeUserManager(newValue);
        },
        value: controller.selectedUserManager.value,
        items: controller.managerUsers.map((UserDetails item) {
          return DropdownMenuItem(
            child: new Text(
              item.name,
            ),
            value: item,
          );
        }).toList(),
      );
    });
  }

  _getPeriodicMantenancceDetailsWidget() {
    return Obx(() {
      if (controller.hasPeriodicMaintenance != true)
        return getCommonBoxWidget(10, 10);

      return Container(
        child: Column(
          children: [
            getCommonNumberInputFieldWidget(CScheduledMaintenancePeriodDays,
                controller.scheduleMaintenancePeriodController, null),
            const SizedBox(height: defaultPadding * 1),
            getCommonDateSelectionPicker(
                controller.lastPeriodicServiceDateWrapper,
                CLastPeriodicServiceDate,
                true),
          ],
        ),
      );
    });
  }

  // _getUserAdminDropDown() {
  //   return Obx(() {
  //     if (controller.adminUsers.isEmpty) return getCommonProgressWidget();
  //
  //     if (controller.selectedUserAdmin.value.uuid == null)
  //       controller.selectedUserAdmin.value = controller.adminUsers[0];
  //     return DropdownButton(
  //       hint: Text(
  //         'Select User Admin',
  //       ),
  //       onChanged: (newValue) {
  //         controller.changeUserAdmin(newValue);
  //       },
  //       value: controller.selectedUserAdmin.value,
  //       items: controller.adminUsers.map((UserDetails item) {
  //         return DropdownMenuItem(
  //           child: new Text(
  //             item.name,
  //           ),
  //           value: item,
  //         );
  //       }).toList(),
  //     );
  //   });
  // }

  _getAddAndPreviewImageWidget() {
    return Obx(() {
      return getCommonAddAndPreviewImageWidget(controller.image);
    });
  }

  _getHasPeriodicMaintenanceOrNotSelectionWidget() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Has Periodic Maintenance?'),
          CupertinoSwitch(
            value: controller.hasPeriodicMaintenance.value,
            onChanged: (value) {
              controller.hasPeriodicMaintenance.value = value;
            },
          ),
        ],
      );
    });
  }
}

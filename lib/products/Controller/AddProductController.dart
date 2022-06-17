import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../FirebaseManager/EquipmentManager.dart';
import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../../common/DataClasses.dart';
import '../../common/Extentions.dart';
import '../../common/globalFunctions.dart';
import '../../main.dart';
import '../Model/EquipmentDetails.dart';
import 'ProductListController.dart';

class AddProductController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final serialNoController = TextEditingController();
  final detailsController = TextEditingController();
  final addressController = TextEditingController();
  final warrantyPeriodController = TextEditingController();
  final scheduleMaintenancePeriodController = TextEditingController();
  var isLoading = false;
  var selectedUserManager = UserDetails().obs;
  var selectedUserAdmin = UserDetails().obs;
  var managerUsers = <UserDetails>[].obs;
  var adminUsers = <UserDetails>[].obs;
  var image = XFile("").obs;
  PrimitiveWrapper purchaseDateWrapper = PrimitiveWrapper("");
  PrimitiveWrapper lastPeriodicServiceDateWrapper = PrimitiveWrapper("");
  var hasPeriodicMaintenance = false.obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    modelController.dispose();
    serialNoController.dispose();
    detailsController.dispose();
    addressController.dispose();
    warrantyPeriodController.dispose();
    scheduleMaintenancePeriodController.dispose();

    selectedUserManager.close();
    selectedUserAdmin.close();
    managerUsers.close();
    adminUsers.close();
    image.close();
    hasPeriodicMaintenance.close();
    super.onClose();
  }

  Future<void> saveAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            if (image.value.path.isEmpty) {
              showCustomSnackBar('Add Image', 'Please select Equipment Photo');
              return;
            }
            var request = EquipmentDetails();
            request.name = nameController.text;
            request.serialNumber = serialNoController.text;
            request.model = modelController.text;
            request.details = detailsController.text;
            request.address = addressController.text;
            request.warrantyPeriodInYears = warrantyPeriodController.text;

            var userCode = currentUserDetails?.code ?? "";
            var userRole = currentUserDetails?.userRole ?? "";
            if (isNotAppleTester()) {
              request.userManagerCode = selectedUserManager.value.code ?? "";
              request.userManagerName = selectedUserManager.value.name;
              //For current version no user admin
              // request.userAdminCode = selectedUserAdmin.value.code ?? "";
              // request.userAdminName = selectedUserAdmin.value.name;
            } else {
              request.userManagerCode = userCode;
              request.userManagerName = userRole;
              //For current version no user admin
              // request.userAdminCode = userCode;
              // request.userAdminName = userRole;
            }

            request.purchaseDate =
                getTimestampFromString(purchaseDateWrapper.value);
            request.isHavingPeriodicMaintenance = hasPeriodicMaintenance.value;
            if (hasPeriodicMaintenance.value) {
              if (scheduleMaintenancePeriodController.text.isEmpty) {
                showCustomSnackBar(
                    'Failed', 'Please enter $CScheduledMaintenancePeriodDays');
                return;
              }
              request.scheduleMaintenancePeriodInDays =
                  scheduleMaintenancePeriodController.text;
              request.lastAutoCreatedServiceDiagnisedDate =
                  getTimestampFromString(lastPeriodicServiceDateWrapper.value);
            }

            request.photoPaths = [image.value.path];
            var saved = await addNewEquipment(request);
            if (saved) {
              ProductListController listController = Get.find();
              listController.getEquipments();
              Get.back();
            } else {
              showCustomSnackBar('Failed', 'Failed to Save details');
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  void changeUserManager(Object? request) =>
      selectedUserManager.value = request as UserDetails;

  void changeUserAdmin(Object? request) =>
      selectedUserAdmin.value = request as UserDetails;
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../../common/CommonWidgets.dart';
import '../../common/DataClasses.dart';
import '../../common/Extentions.dart';
import '../../common/globalFunctions.dart';
import '../../main.dart';
import '../Model/RequestDetails.dart';
import 'PendingRequestListController.dart';

class ScheduleRequestController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  var isLoading = false;

  PrimitiveWrapper scheduledServiceDateWrapper = PrimitiveWrapper("");

  var details;

  var selectedServiceEngineer = UserDetails().obs;
  var serviceEngineers = <UserDetails>[].obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    // titleController.text = 'title';
    super.onInit();
  }

  @override
  void onClose() {
    selectedServiceEngineer.close();
    serviceEngineers.close();
    super.onClose();
  }

  String? validator(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'Please this field must be filled';
    }
    return null;
  }

  Future<void> ignoreAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            isLoading = true;
            RequestDetails request = details;
            var submitted = await markAsIgnoredRequest(request);
            if (submitted) {
              PendingRequestListController listController = Get.find();
              listController.getPendingRequests();
              Get.back();
            } else {
              showCustomSnackBar('Failed', 'Failed to update details');
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  Future<void> saveAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            isLoading = true;
            RequestDetails request = details;

            var userCode = currentUserDetails?.code ?? "";
            var userName = currentUserDetails?.name ?? "";
            var phoneNo = currentUserDetails?.phoneNo ?? "";
            if (isNotAppleTester()) {
              request.serviceEngineerCode = selectedServiceEngineer.value.code;
              request.serviceEngineerName = selectedServiceEngineer.value.name;
              request.serviceEngineerPhoneNo =
                  selectedServiceEngineer.value.phoneNo;
            } else {
              request.serviceEngineerCode = userCode;
              request.serviceEngineerName = userName;
              request.serviceEngineerPhoneNo = phoneNo;
            }

            request.scheduledDateTime =
                getTimestampFromString(scheduledServiceDateWrapper.value);
            var submitted =
                await scheduleRequest(request, selectedServiceEngineer.value);
            if (submitted) {
              // showCustomeSnackBar('Success', 'Added new request successfully');
              Get.back();
            } else {
              showCustomSnackBar('Failed', 'Failed to update details');
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  void changeEngineer(Object? request) =>
      selectedServiceEngineer.value = request as UserDetails;
}

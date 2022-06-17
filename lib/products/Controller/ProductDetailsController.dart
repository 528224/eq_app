import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../FirebaseManager/EquipmentManager.dart';
import '../../FirebaseManager/RequestManager.dart';
import '../../common/CommonWidgets.dart';
import '../../request/Model/RequestDetails.dart';
import '../Model/EquipmentDetails.dart';
import 'ProductListController.dart';

class ProductDetailsController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  EquipmentDetails? details;
  var requests = <RequestDetails>[].obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
  }

  @override
  void onClose() {
    requests.close();
    super.onClose();
  }

  Future<void> getRequests() async {
    requests.value = await getRequestListForProduct(details?.documentId ?? "");
  }

  Future<void> deleteAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          var saved = await deleteEquipment(details?.documentId ?? "");
          if (saved) {
            ProductListController listController = Get.find();
            listController.getEquipments();
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

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../../common/CommonWidgets.dart';
import '../../products/Model/EquipmentDetails.dart';
import '../Model/RequestDetails.dart';
import 'PendingRequestListController.dart';

class RequestController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  var isLoading = false;

  var selectedProduct = EquipmentDetails().obs;
  var products = <EquipmentDetails>[].obs;
  var image = XFile("").obs;
  var video = XFile("").obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    // titleController.text = 'title';
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    selectedProduct.close();
    products.close();
    image.close();
    video.close();
    super.onClose();
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
            isLoading = true;
            var details = RequestDetails();
            details.title = titleController.text;
            details.description = descriptionController.text;
            details.eqFirestoreId = selectedProduct.value.documentId;
            details.equipment = selectedProduct.value;
            details.requestPhotoPaths = [image.value.path];
            details.requestVideoPaths = [video.value.path];
            var submitted = await addNewRequest(details);
            if (submitted) {
              try {
                PendingRequestListController listController = Get.find();
                listController.getPendingRequests();
              } catch (e) {}
              Get.back();
            } else {
              showCustomSnackBar(
                  'Failed', 'Failed to Add new request successfully');
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  void changeProduct(Object? request) =>
      selectedProduct.value = request as EquipmentDetails;
}

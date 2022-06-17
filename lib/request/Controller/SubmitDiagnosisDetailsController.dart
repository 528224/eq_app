import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../../common/CommonWidgets.dart';
import '../Model/RequestDetails.dart';
import 'PendingRequestListController.dart';

class SubmitDiagnosisDetailsController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  final serviceCommentController = TextEditingController();
  var isLoading = false;

  var details;
  var image = XFile("").obs;
  var isIssueSolved = true.obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    // titleController.text = 'title';
    super.onInit();
  }

  @override
  void onClose() {
    serviceCommentController.dispose();
    image.close();
    isIssueSolved.close();
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
            RequestDetails request = details;
            request.serviceEngineerComment = serviceCommentController.text;
            request.servicePhotoPaths = [image.value.path];
            request.isIssueFixed = isIssueSolved.value;
            var submitted = await SubmitDiagnosisForServiceRequest(request);
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
}

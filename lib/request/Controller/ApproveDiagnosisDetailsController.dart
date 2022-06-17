import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../../common/CommonWidgets.dart';
import '../Model/RequestDetails.dart';
import 'PendingRequestListController.dart';

class ApproveDiagnosisDetailsController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  var isLoading = false;
  var pdfServiceReport = XFile("").obs;

  var details;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    // titleController.text = 'title';
    super.onInit();
  }

  @override
  void onClose() {
    pdfServiceReport.close();
    super.onClose();
  }

  String? validator(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'Please this field must be filled';
    }
    return null;
  }

  Future<void> approveAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            isLoading = true;
            RequestDetails request = details;
            request.reportPdfPath = pdfServiceReport.value.path;
            var saved = await ApproveDiagnosisOfServiceRequest(request);
            if (saved) {
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

  Future<void> uploadReportPdfAction() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
  }
}

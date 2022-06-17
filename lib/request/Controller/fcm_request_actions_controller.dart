import 'package:get/get.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../../common/Constants.dart';
import '../../main.dart';
import '../Model/RequestDetails.dart';
import '../pending_requests/approve_service_widget.dart';
import '../pending_requests/schedule_request_details_widget.dart';
import '../pending_requests/submit_service_widget.dart';
import '../request_history/request_history_details_widget.dart';

class FCMRequestActionsController extends GetxController {
  var request = RequestDetails().obs;

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    // titleController.text = 'title';
    super.onInit();
  }

  @override
  void onClose() {
    request.close();
    super.onClose();
  }

  Future<void> getDetails(String docId) async {
    var details = await getRequestDetails(docId);

    var reqStatus = details.status;
    var isActionsRequired = false;
    var userRole = currentUserDetails?.userRole ?? "";
    if (userRole == UserRoles.serviceEngineer.toString()) {
      if (reqStatus == RequestStatus.scheduled.toString()) {
        isActionsRequired = true;
      }
    } else if (userRole == UserRoles.serviceAdmin.toString()) {
      isActionsRequired = true;
    } else if (userRole == UserRoles.superAdmin.toString()) {
      isActionsRequired = true;
    }

    if (isActionsRequired) {
      _navigateToActionableWidget(details);
    } else {
      Get.off(() => RequestHistoryDetailsWidget(details));
    }
  }

  _navigateToActionableWidget(RequestDetails item) {
    if (item.status == RequestStatus.created.toString()) {
      Get.off(() => ScheduleRequestWidget(item));
    } else if (item.status == RequestStatus.scheduled.toString()) {
      Get.off(() => SubmitServiceWidget(item));
    } else if (item.status == RequestStatus.diagonized.toString()) {
      Get.off(() => ApproveDiagnosisServiceWidget(item));
    }
  }
}

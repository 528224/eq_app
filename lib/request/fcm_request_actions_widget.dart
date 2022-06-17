import 'package:eq_app/request/pending_requests/approve_service_widget.dart';
import 'package:eq_app/request/pending_requests/pending_request_list_widget.dart';
import 'package:eq_app/request/pending_requests/schedule_request_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../common/Extentions.dart';
import '../main.dart';
import 'Controller/fcm_request_actions_controller.dart';
import 'Model/RequestDetails.dart';

class FCMRequestActionsWidget extends StatelessWidget {
  late String requestDocId;
  FCMRequestActionsWidget(this.requestDocId);
  FCMRequestActionsController controller =
      Get.put(FCMRequestActionsController());

  @override
  Widget build(BuildContext context) {
    controller.getDetails(requestDocId);
    return commonScaffold('Details', getCommonProgressWidget());
  }

  Widget _fetchRequestData() {
    return Obx(() {
      var request = controller.request.value;
      return (request.documentId.isNotEmpty)
          ? _getRequestDetails(request)
          : getCommonProgressWidget();
    });
  }

  Widget _getRequestDetails(RequestDetails item) {
    var title = "";
    var subTitle = "";

    var reqStatus = item.status;
    var isActionsRequired = false;
    var userRole = currentUserDetails?.userRole ?? "";
    if (userRole == UserRoles.userManager.toString() ||
        userRole == UserRoles.userAdmin.toString()) {
      if (reqStatus == RequestStatus.created.toString()) {
        isActionsRequired = true;
      }
    } else if (userRole == UserRoles.serviceEngineer.toString()) {
      if (reqStatus == RequestStatus.scheduled.toString()) {
        isActionsRequired = true;
      }
    } else if (userRole == UserRoles.serviceAdmin.toString()) {
      isActionsRequired = true;
    } else if (userRole == UserRoles.superAdmin.toString()) {
      isActionsRequired = true;
    }

    if (reqStatus == RequestStatus.created.toString()) {
      title =
          'A complaint has been registered on ${getStringFromTimestamp(item.createdDate)}';
      subTitle =
          'Machine name: ${item.equipment?.name ?? ""} \nModel no : ${item.equipment?.model ?? ""} \nComplaint details : “ ${item.title}, ${item.description}”';
    } else if (reqStatus == RequestStatus.scheduled.toString()) {
      title =
          'The service provider has scheduled a date for site visit against the complaint registered on ${getStringFromTimestamp(item.scheduledDateTime)}';
      subTitle =
          'Machine name: ${item.equipment?.name ?? ""} \nModel no : ${item.equipment?.model ?? ""} \nComplaint details : “ ${item.title}, ${item.description}”';
      if (userRole != UserRoles.serviceEngineer.toString()) {
        subTitle =
            subTitle + "\nAssigned engineer: ${item.serviceEngineerName}";
      }
    } else if (reqStatus == RequestStatus.diagonized.toString()) {
      title =
          'Authorized diagnosis report has been submitted. \ndate of visit : ${getStringFromTimestamp(item.servicedDateTime)} \nStatus : ${item.getResolvedStatus()} \nService  Engineer:  ${item.serviceEngineerName}';
      subTitle =
          'Equipment details: ${item.equipment?.name ?? ""} \nModel no: ${item.equipment?.model ?? ""} \nDiagnosis details : “ ${item.serviceEngineerComment} ”';
    }

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(title),
              subtitle: Text(subTitle),
            ),
            _getActionsWidget(item, isActionsRequired)
          ],
        ),
      ),
    );
  }

  _getActionsWidget(RequestDetails item, bool isActionsRequired) {
    if (isActionsRequired) {
      if (item.status == RequestStatus.created.toString()) {
        return _getActionsWidgetForNewlyCreatedRequest(item);
      } else if (item.status == RequestStatus.scheduled.toString()) {
        return _getActionsWidgetForScheduledRequest(item);
      } else if (item.status == RequestStatus.diagonized.toString()) {
        return _getActionsWidgetForDiagonisedRequest(item);
      }
    }
    return _getDefaultActionsWidget();
  }

  _getActionsWidgetForNewlyCreatedRequest(RequestDetails item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          child: const Text('SCHEDULE VISIT'),
          onPressed: () {
            Get.to(() => ScheduleRequestWidget(item));
          },
        ),
        const SizedBox(width: 8),
        TextButton(
          child: const Text('MARK AS IGNORED'),
          onPressed: () {
            Get.to(() => ScheduleRequestWidget(item));
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  _getActionsWidgetForScheduledRequest(RequestDetails item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          child: const Text('SEE ALL SCHEDULES'),
          onPressed: () {
            Get.to(() => PendingRequestListWidget(List.empty()));
          },
        ),
        const SizedBox(width: 8),
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Get.back();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  _getActionsWidgetForDiagonisedRequest(RequestDetails item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          child: const Text('APPROVE'),
          onPressed: () {
            Get.to(() => ApproveDiagnosisServiceWidget(item));
          },
        ),
        const SizedBox(width: 8),
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Get.back();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  _getDefaultActionsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Get.back();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

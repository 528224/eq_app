import 'package:eq_app/request/pending_requests/pending_request_item_widget.dart';
import 'package:eq_app/request/pending_requests/schedule_request_details_widget.dart';
import 'package:eq_app/request/pending_requests/submit_service_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../../common/globalFunctions.dart';
import '../../main.dart';
import '../Controller/PendingRequestListController.dart';
import '../Model/RequestDetails.dart';
import '../request_history/request_history_details_widget.dart';
import 'approve_service_widget.dart';

class PendingRequestListWidget extends StatefulWidget {
  List<RequestDetails> requests = List.empty(growable: true);

  PendingRequestListWidget(this.requests);

  @override
  State<PendingRequestListWidget> createState() =>
      _PendingRequestListWidgetState();
}

class _PendingRequestListWidgetState extends State<PendingRequestListWidget>
    with TickerProviderStateMixin {
  PendingRequestListController controller =
      Get.put(PendingRequestListController());
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
        'Pending Requests',
        (widget.requests.isNotEmpty)
            ? _createListData(widget.requests)
            : _cateFutureListData());
  }

  _cateFutureListData() {
    return Obx(() {
      var items = controller.requests.value;
      if (items.isNotEmpty) {
        return _createListData(items);
      } else if (controller.isLoading.value) {
        return getCommonProgressWidget();
      } else {
        return getNoDataWidget();
      }
    });
  }

  _createListData(List<RequestDetails> items) {
    return Scrollbar(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final int count = items.length > 10 ? 10 : items.length;
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));
          animationController.forward();

          return PendingRequestItemWidget(
              details: items[index],
              animationController: animationController,
              animation: animation,
              callback: () {
                _requestSelectionManagement(items[index]);
              });
        },
      ),
    );
  }

  _requestSelectionManagement(RequestDetails details) {
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
    } else if (isAppleTester()) {
      isActionsRequired = true;
    }

    if (isActionsRequired) {
      _navigateToRequestDetails(details);
    } else {
      Get.to(() => RequestHistoryDetailsWidget(details));
    }
  }

  _navigateToRequestDetails(RequestDetails item) {
    if (item.status == RequestStatus.created.toString()) {
      Get.to(() => ScheduleRequestWidget(item));
    } else if (item.status == RequestStatus.scheduled.toString()) {
      Get.to(() => SubmitServiceWidget(item));
    } else if (item.status == RequestStatus.diagonized.toString()) {
      Get.to(() => ApproveDiagnosisServiceWidget(item));
    }
  }
}

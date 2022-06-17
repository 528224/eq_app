import 'package:eq_app/products/View/qr_code_generation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../common/AppTheme.dart';
import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../../common/Extentions.dart';
import '../../common/globalFunctions.dart';
import '../../main.dart';
import '../../request/Model/RequestDetails.dart';
import '../../request/request_history/request_history_details_widget.dart';
import '../Controller/ProductDetailsController.dart';
import '../Model/EquipmentDetails.dart';
import 'UpdateProductWidget.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget(this.details);

  ProductDetailsController controller = Get.put(ProductDetailsController());
  EquipmentDetails details;

  @override
  Widget build(BuildContext context) {
    controller.details = details;
    controller.getRequests();
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(details.name.toUpperCase()),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Timeline'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _getDetailsTabContent(),
              _getTimelineTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  _getDetailsTabContent() {
    return SingleChildScrollView(
      child: Container(
        // padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.requestFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (details.photoUrls.isNotEmpty == true)
                getRemoteImageViewWidget(details.photoUrls[0]),
              const SizedBox(height: defaultPadding * 0.75),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: getCommonSectionHeaderWidget(
                          details.name.toUpperCase(), Alignment.centerLeft),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4, right: 12),
                      child: Text(
                        '${details.getWorkingStatus()}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                            color: details.getWorkingStatusColor(),
                            fontSize: 16),
                      ),
                    ),
                  ]),
              getCommonLabelWidget(details.model, CModelNo),
              getCommonLabelWidget(details.serialNumber, CSerialNo),
              getCommonLabelWidget(
                  getStringFromTimestamp(details.purchaseDate), CPurchasedDate),
              if (details.warrantyPeriodInYears.isNotEmpty == true)
                getCommonLabelWidget(
                    details.warrantyPeriodInYears, CWarrantyPeriodYears),
              if (details.isHavingPeriodicMaintenance == true)
                getCommonLabelWidget(details.scheduleMaintenancePeriodInDays,
                    CScheduledMaintenancePeriodDays),
              if (details.isHavingPeriodicMaintenance == true)
                getCommonLabelWidget(
                    getStringFromTimestamp(
                        details.lastAutoCreatedServiceDiagnisedDate),
                    CLastPeriodicServiceDate),
              if (details.isHavingPeriodicMaintenance == true)
                getCommonLabelWidget(
                    getDaysSince(details.lastAutoCreatedServiceDiagnisedDate)
                        .toString(),
                    CDaysSinceLastScheduledMaintenance),
              if (isNotAppleTester())
                getCommonLabelWidget(details.userManagerName, CAssignedUser),
              // if (isNotAppleTester() &&
              //     (details?.userAdminName ?? "").isNotEmpty)
              //   getCommonLabelWidget(details?.userAdminName, CUserAdmin),
              if (details.address.isNotEmpty == true)
                getCommonSectionWidget(CAddress, details.address),
              if (details.details.isNotEmpty == true)
                if (details.details.isNotEmpty == true)
                  getCommonSectionWidget(CEquipmentDetails, details.details),
              if (currentUserDetails?.canUpdateEquipment() == true)
                TextButton(
                  onPressed: () {
                    Get.to(() => UpdateProductWidget(details));
                  },
                  child: Text('Update Details'),
                ),
              if (currentUserDetails?.canUpdateEquipment() == true)
                TextButton(
                  onPressed: deleteButtonAction,
                  child: Text('Delete Equipment'),
                ),
              if (currentUserDetails?.canViewQRCode() == true)
                TextButton(
                  onPressed: () {
                    qrCodeButtonAction(details.serialNumber);
                  },
                  child: Text('QR Code'),
                ),
              // getCommonBackgroundWidget(24.0),
              // getCommonSectionHeaderWidget('Timeline', Alignment.center),
              // _cateRequestFutureListData(),
              const SizedBox(height: defaultPadding * 0.75),
            ],
          ),
        ),
      ),
    );
  }

  _getTimelineTabContent() {
    return SingleChildScrollView(
      child: Container(
        child: _cateRequestFutureListData(),
      ),
    );
  }

  _cateRequestFutureListData() {
    return Obx(() {
      var items = controller.requests.value;
      if (items.isNotEmpty) {
        return _createRequestListData(items);
      } else {
        return Text('No request history found');
      }
    });
  }

  _createRequestListData(List<RequestDetails> items) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var isFirst = index == 0;
          var isLast = items.length == index + 1;
          return GestureDetector(
            child: _getTimelineWidget(items[index], isFirst, isLast),
            onTap: () {
              Get.to(() => RequestHistoryDetailsWidget(items[index]));
            },
          );
        },
      ),
    );
  }

  _getTimelineWidget(RequestDetails details, bool isFirst, bool isLast) {
    var color = (details.status == RequestStatus.ignored.toString() ||
            details.status == RequestStatus.completed.toString())
        ? AppThemes.getFocusColor()
        : AppThemes.getSecondaryColor();
    var indicatorStyle = IndicatorStyle(color: AppThemes.getPrimaryColor());
    var beforeLineStyle = LineStyle(color: AppThemes.getPrimaryColor());
    return TimelineTile(
      alignment: TimelineAlign.center,
      isFirst: isFirst,
      isLast: isLast,
      startChild: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 4),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(
            getStringFromTimestamp(details.getUpdatedTimeStamp()) ?? "",
            style: AppTextStyles().kTextStyleWithFont,
          ),
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(4))),
        ),
      ),
      endChild: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 4),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(details.getStatusText(),
              style: AppTextStyles().kTextStyleWithFont),
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(4))),
        ),
      ),
      indicatorStyle: indicatorStyle,
      beforeLineStyle: beforeLineStyle,
    );
  }

  _getPeriodicMantenancceDetailsWidget() {
    if (details.isHavingPeriodicMaintenance != true)
      return getCommonBoxWidget(10, 10);

    return Container(
      child: Column(
        children: [
          getCommonLabelWidget(details.scheduleMaintenancePeriodInDays,
              CScheduledMaintenancePeriodDays),
          getCommonLabelWidget(
              getStringFromTimestamp(
                  details.lastAutoCreatedServiceDiagnisedDate),
              CLastPeriodicServiceDate),
          getCommonLabelWidget(
              getDaysSince(details.lastAutoCreatedServiceDiagnisedDate)
                  .toString(),
              CDaysSinceLastScheduledMaintenance),
        ],
      ),
    );
  }

  deleteButtonAction() {
    Get.defaultDialog(
      textCancel: "NO",
      textConfirm: "YES",
      title: "Delete Equipment",
      content: Text(
        "Are you sure you want to delete this equipment?",
        style: AppTextStyles().kTextStyleWithFont,
      ),
      onCancel: () {},
      onConfirm: controller.deleteAction,
    );
  }

  qrCodeButtonAction(String data) {
    Get.to(() => QRCodeGenerationWidget(data));
  }
}

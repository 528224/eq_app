import 'package:eq_app/request/request_history/request_history_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/CommonWidgets.dart';
import '../../common/Extentions.dart';
import '../Model/RequestDetails.dart';

class RequestHistoryItemWidget extends StatelessWidget {
  late RequestDetails details;
  late AnimationController animationController;
  late Animation<double> animation;

  RequestHistoryItemWidget(
      this.details, this.animationController, this.animation);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Get.to(() => RequestHistoryDetailsWidget(details));
              },
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 10,
                margin: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      getCommonListItemSectionHeaderWidget(
                          details.title, Alignment.centerLeft),
                      getCommonListItemLabelWidget(
                          details.getReferenceNumberText(), 'Ref.No'),
                      getCommonListItemLabelWidget(
                          details.getShortStatusText(), 'Status'),
                      getCommonListItemLabelWidget(
                          getStringFromTimestamp(
                              details.servicedDateTime ?? details.createdDate),
                          (details.servicedDateTime != null)
                              ? 'Serviced On'
                              : 'Registered On'),
                      getCommonListItemLabelWidget(
                          details.equipment?.name, 'Device'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

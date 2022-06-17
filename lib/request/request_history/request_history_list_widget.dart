import 'package:eq_app/request/request_history/request_history_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../../common/CommonWidgets.dart';
import '../Model/RequestDetails.dart';

class RequestHistoryListWidget extends StatefulWidget {
  late String eqFirestoreId;
  RequestHistoryListWidget(this.eqFirestoreId);

  @override
  _RequestHistoryListWidgetState createState() =>
      _RequestHistoryListWidgetState();
}

class _RequestHistoryListWidgetState extends State<RequestHistoryListWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
        'Request History', _cateFutureListData(widget.eqFirestoreId));
  }

  _cateFutureListData(String eqFirestoreId) {
    return FutureBuilder(
        future: (eqFirestoreId.isBlank == true)
            ? getRequestHistoryList()
            : getRequestListForProduct(eqFirestoreId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<RequestDetails> items = snapshot.data as List<RequestDetails>;
            return items.isNotEmpty
                ? _createListData(items)
                : getNoDataWidget();
          } else if (snapshot.hasError) {
            return getCommonErrorWidget();
          } else {
            return getCommonProgressWidget();
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

          return RequestHistoryItemWidget(
              items[index], animationController, animation);
        },
      ),
    );
  }
}

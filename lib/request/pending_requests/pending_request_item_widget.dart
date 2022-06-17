import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/CommonWidgets.dart';
import '../../common/Extentions.dart';
import '../Model/RequestDetails.dart';

class PendingRequestItemWidget extends StatelessWidget {
  const PendingRequestItemWidget(
      {Key? key,
      required this.details,
      required this.animationController,
      required this.animation,
      required this.callback})
      : super(key: key);

  final RequestDetails details;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    var imageUrl = "";
    if (details.requestPhotoUrls.isNotEmpty)
      imageUrl = details.requestPhotoUrls.first;
    if (details.servicePhotoUrls.isNotEmpty)
      imageUrl = details.servicePhotoUrls.first;
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
                callback();
              },
              child: Container(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10,
                  margin:
                      EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // if (imageUrl.isNotEmpty)
                        //   Flexible(
                        //     flex: 1,
                        //     child: Container(
                        //       height: 100,
                        //       child: getImageWidget(
                        //           imageUrl, 'assets/placeholders/hotel_1.png'),
                        //     ),
                        //   ),
                        // if (imageUrl.isNotEmpty)
                        //   SizedBox(
                        //     width: 8,
                        //   ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              getCommonListItemSectionHeaderWidget(
                                  details.title, Alignment.centerLeft),
                              getCommonListItemLabelWidget(
                                  details.getReferenceNumberText(), 'Ref.No'),
                              getCommonListItemLabelWidget(
                                  details.getShortStatusText(), 'Status'),
                              getCommonListItemLabelWidget(
                                  getStringFromTimestamp(details.createdDate),
                                  'Reported On'),
                              getCommonListItemLabelWidget(
                                  details.equipment?.name, 'Device'),
                            ],
                          ),
                        ),

                        // Text(widget.orderHistoryReponseData.),
                      ],
                    ),
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

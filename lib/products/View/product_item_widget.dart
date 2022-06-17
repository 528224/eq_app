import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/AppTheme.dart';
import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../Model/EquipmentDetails.dart';

class ProductTypeItemWidget extends StatelessWidget {
  const ProductTypeItemWidget(
      {Key? key,
      required this.equipmentDetails,
      required this.animationController,
      required this.animation,
      required this.callback})
      : super(key: key);

  final EquipmentDetails equipmentDetails;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback callback;

  // MockTestListItemWidget(this.item);
  @override
  Widget build(BuildContext context) {
    var imagePath = "";
    if (equipmentDetails.photoUrls.isNotEmpty)
      imagePath = equipmentDetails.photoUrls.first;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Get.isDarkMode
                            ? Colors.grey.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: getImageWidget(
                                  imagePath, 'assets/placeholders/hotel_1.png'),
                            ),
                            Container(
                              color: Get.isDarkMode
                                  ? Colors.black45
                                  : Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            top: 8,
                                            bottom: 8,
                                            right: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      equipmentDetails.name
                                                          .toUpperCase(),
                                                      textAlign: TextAlign.left,
                                                      style: AppTextStyles()
                                                          .kTextStyleEighteenBoldWithThemeColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${equipmentDetails.getWorkingStatus()}',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.montserrat(
                                                        color: equipmentDetails
                                                            .getWorkingStatusColor(),
                                                        fontSize: 16),
                                                  ),
                                                ]),
                                            const SizedBox(
                                                height: defaultPadding * 0.5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Model: ${equipmentDetails.model}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyles()
                                                      .kTextStyleWithFont,
                                                ),
                                                Text(
                                                  "Serial: ${equipmentDetails.serialNumber}",
                                                  style: AppTextStyles()
                                                      .kTextStyleWithFont,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //   'User: ${equipmentDetails.userManagerName}',
                                            //   style: AppTextStyles()
                                            //       .kTextStyleWithFont,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Positioned(
                        //   top: 8,
                        //   right: 8,
                        //   child: Material(
                        //     color: Colors.transparent,
                        //     child: InkWell(
                        //       borderRadius: const BorderRadius.all(
                        //         Radius.circular(32.0),
                        //       ),
                        //       onTap: () {},
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Icon(
                        //           Icons.favorite_border,
                        //           // color: HotelAppTheme.buildLightTheme()
                        //           //     .primaryColor,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
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

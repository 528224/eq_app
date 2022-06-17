import 'package:eq_app/products/View/product_item_widget.dart';
import 'package:eq_app/products/View/scann_qr_code_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../common/AppTheme.dart';
import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../../main.dart';
import '../Controller/ProductListController.dart';
import '../Model/EquipmentDetails.dart';
import 'AddNewProductWidget.dart';
import 'ProductDetailsWidget.dart';

class ProductListWidget extends StatefulWidget {
  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget>
    with TickerProviderStateMixin {
  ProductListController controller = Get.put(ProductListController());

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
    var floatingAction = _getFloatingActionButton();
    return commonScaffold('Equipments', _createBody(), floatingAction);
  }

  void addAction() {
    Get.to(() => AddNewProductWidget());
  }

  _createBody() {
    return Column(
      children: <Widget>[getSearchBarUI(), _cateFutureListData()],
    );
  }

  _cateFutureListData() {
    return Obx(() {
      var items = controller.equipments;
      if (items.isNotEmpty) {
        return _createListData(items);
      } else if (controller.isLoading.value) {
        return getCommonProgressWidget();
      } else {
        return getNoDataWidget();
      }
    });
  }

  _createListData(List<EquipmentDetails> items) {
    return Expanded(
      child: Scrollbar(
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

            return ProductTypeItemWidget(
                equipmentDetails: items[index],
                animationController: animationController,
                animation: animation,
                callback: () {
                  Get.to(() => ProductDetailsWidget(items[index]));
                });
          },
        ),
      ),
    );
  }

  _getFloatingActionButton() {
    var userRole = currentUserDetails?.userRole ?? "";
    if (userRole == UserRoles.superAdmin.toString() ||
        userRole == UserRoles.appleTester.toString()) {
      return FloatingAddIconButton(addAction, 'Add Equipment');
    }
    return null;
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppThemes.getBackgroundColor(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(22.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        // color: AppThemes.getPrimaryColor(),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (String txt) {
                      controller.updateEquipments();
                    },
                    style: AppTextStyles().kTextStyleWithFont,
                    cursorColor: AppThemes.getSecondaryColor(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppThemes.getPrimaryColor(),
              borderRadius: const BorderRadius.all(
                Radius.circular(22.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(22.0),
                ),
                onTap: () {
                  Get.to(() => QRViewExample((String data) {
                        controller.searchController.text = data;
                        controller.updateEquipments();
                      }));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FaIcon(
                    FontAwesomeIcons.qrcode,
                    size: 16,
                    color: AppThemes.getBackgroundColor(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

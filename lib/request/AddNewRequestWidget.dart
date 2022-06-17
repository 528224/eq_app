import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../FirebaseManager/EquipmentManager.dart';
import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../products/Model/EquipmentDetails.dart';
import 'Controller/AddRequestController.dart';

class AddNewRequestWidget extends StatelessWidget {
  AddNewRequestWidget({Key? key}) : super(key: key);
  RequestController controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    _getList();
    return Scaffold(
      appBar: AppBar(title: Text('Add New Request')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.requestFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding * 2),
                TextFormField(
                  controller: controller.titleController,
                  decoration: textFieldDecoration(CTitle),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 100,
                ),
                const SizedBox(height: defaultPadding * 1),
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: textFieldDecoration(CDescription),
                  validator: controller.validator,
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 500,
                ),
                const SizedBox(height: defaultPadding * 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(CEquipmentName),
                    _getProductDropDown(),
                  ],
                ),
                const SizedBox(height: defaultPadding * 1),
                _getAddAndPreviewImageWidget(),
                const SizedBox(height: defaultPadding * 1),
                _getAddAndPreviewVideoWidget(),
                getCommonBackgroundWidget(24.0),
                getCommonSaveAndCancelButtons("Submit", controller.saveAction),
                getCommonBackgroundWidget(24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getList() async {
    var list = await getEquipmentList();
    controller.products.value = list;
  }

  _getProductDropDown() {
    return Obx(() {
      if (controller.products.isEmpty) return getCommonProgressWidget();

      if (controller.selectedProduct.value.documentId.isEmpty)
        controller.selectedProduct.value = controller.products[0];
      return DropdownButton(
        hint: Text(
          'Equipment Name',
        ),
        onChanged: (newValue) {
          controller.changeProduct(newValue);
        },
        value: controller.selectedProduct.value,
        items: controller.products.map((EquipmentDetails item) {
          return DropdownMenuItem(
            child: new Text(
              item.name,
            ),
            value: item,
          );
        }).toList(),
      );
    });
  }

  _getAddAndPreviewImageWidget() {
    return Obx(() {
      return getCommonAddAndPreviewImageWidget(controller.image);
    });
  }

  _getAddAndPreviewVideoWidget() {
    return Obx(() {
      return getCommonAddAndPreviewVideoWidget(controller.video);
    });
  }
}

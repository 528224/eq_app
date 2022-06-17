import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../FirebaseManager/EquipmentManager.dart';
import '../Model/EquipmentDetails.dart';

class ProductListController extends GetxController {
  var allEquipments = <EquipmentDetails>[];
  var equipments = <EquipmentDetails>[].obs;
  var isLoading = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    getEquipments();
    super.onInit();
  }

  @override
  void onClose() {
    equipments.close();
    isLoading.close();
    searchController.clear();
    super.onClose();
  }

  Future<void> getEquipments() async {
    isLoading.value = true;
    allEquipments = await getEquipmentList();
    updateEquipments();
    isLoading.value = false;
  }

  updateEquipments() {
    var searchText = searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      equipments.value = allEquipments
          .where((element) =>
              element.name.toLowerCase().contains(searchText) ||
              element.model.toLowerCase().contains(searchText) ||
              element.serialNumber.toLowerCase().contains(searchText))
          .toList(growable: true);
    } else {
      equipments.value = allEquipments;
    }
  }
}

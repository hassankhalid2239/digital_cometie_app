import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class StateController extends GetxController {
  RxInt getPageIndex = 0.obs;
  RxDouble currentValue = 3.0.obs;
  RxBool note = false.obs;
  RxInt profileFilterCometie=0.obs;
  final Rx<PageController> pageController = PageController().obs;

  RxString searchQuery = 'Search query'.obs;

  void updateSearchQuery(String newQuery) {
      searchQuery.value = newQuery;
  }
  Rx<Country> selectedCountry = Country(
      phoneCode: "92",
      countryCode: "PK",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Pakistan',
      example: 'Pakistan',
      displayName: 'Pakistan',
      displayNameNoCountryCode: 'PK',
      e164Key: "").obs;
}

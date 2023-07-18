import 'dart:async';

import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../../../services/notification_services.dart';
import '../../home_screen/view/home_view.dart';
import '../../login_screen/view/login_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigate_to_homescreen();
    super.onInit();
  }

  navigate_to_homescreen() async {
    Timer(Duration(seconds: 4), () {
      if (Get.find<StorageServices>().storage.read('id') == null) {
        Get.offAll(() => LoginView());
      } else {
        Get.offAll(() => HomeView());
        Get.find<NotificationServices>().getToken();
      }
    });
  }
}

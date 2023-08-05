import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tm/src/home_screen/view/home_view.dart';
import 'package:http/http.dart' as http;
import '../../../services/getstorage_services.dart';
import '../../../services/notification_services.dart';
import '../widget/login_screen_alertdialog.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  senfEmailNotif(
      {required String user_email,
      required String user_name,
      required String devicename}) async {
    var response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': 'service_7s3b9q8',
          'template_id': 'template_luidupf',
          'user_id': 'tkHshAKjI_XQ7pDZR',
          'template_params': {
            'user_name': user_name,
            'user_email': user_email,
            'user_subject': 'New Device login',
            'user_message':
                'your account was logged in from another device. Please logout your account from this device $devicename',
          }
        }));
    print(response.statusCode);
  }

  // login function, mo get the ni ug user base sa ge input na username and passwords user if wala makita it means user did not exist if naa automatic mo navigate sa home page
  login() async {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.text)
        .where('password', isEqualTo: password.text)
        .limit(1)
        .get();
    var deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    if (res.docs.length > 0) {
      var userDetails = res.docs[0];
      if (userDetails['deviceID'] == '' ||
          userDetails['deviceID'] == androidDeviceInfo.id) {
        var profileImage = userDetails['image'];

        if (userDetails['image'] == '') {
          profileImage =
              'https://firebasestorage.googleapis.com/v0/b/taskmanagement-45a52.appspot.com/o/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg?alt=media&token=afbc6a11-a050-42a6-8f7b-07f236de02cb';
        }
        Get.find<StorageServices>().saveCredentials(
          id: userDetails.id,
          email: userDetails['email'],
          password: userDetails['password'],
          firstname: userDetails['firstname'],
          lastname: userDetails['lastname'],
          image: profileImage,
          contactno: userDetails['contactno'],
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(res.docs[0].id)
            .update({
          "deviceID": androidDeviceInfo.id,
          "deviceName":
              androidDeviceInfo.brand + " " + androidDeviceInfo.product
        });
        Get.offAll(() => HomeView());
        Get.find<NotificationServices>().getToken();
      } else {
        String deviceName =
            androidDeviceInfo.brand + " " + androidDeviceInfo.product;
        String time = DateFormat('yMMMd').format(DateTime.now()) +
            " " +
            DateFormat('jm').format(DateTime.now());
        LoginAlertDialog.showLoginExist(devicename: userDetails['deviceName']);
        Get.find<NotificationServices>().sendNotification(
            userToken: userDetails['fcmToken'],
            bodymessage: "You login on $deviceName, $time",
            title: "New Device login",
            subtitle: "");
        senfEmailNotif(
            user_email: userDetails['email'],
            user_name: userDetails['firstname'],
            devicename: userDetails['deviceName']);
      }
    } else {
      LoginAlertDialog.showAccountNotFound();
    }
  }
}

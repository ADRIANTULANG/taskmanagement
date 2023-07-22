import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tm/services/getstorage_services.dart';
import 'package:tm/services/notification_services.dart';

import '../../projectdetail_screen/model/projectdetail_members_model.dart';
import '../model/chat_model.dart';

class ChatController extends GetxController {
  RxString project_id = ''.obs;
  RxString project_name = ''.obs;

  RxList<Members> membersList = <Members>[].obs;
  TextEditingController message = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxList<Chats> chatList = <Chats>[].obs;

  Stream? streamChats;
  StreamSubscription<dynamic>? listener;
  @override
  void onInit() async {
    project_id.value = await Get.arguments['project_id'];
    project_name.value = await Get.arguments['project_name'];

    getListenToChats();
    setOnlineTrue();
    super.onInit();
  }

  @override
  void onClose() {
    setOnlineFalse();
    listener!.cancel();
    super.onClose();
  }

  setOnlineTrue() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'))
          .update({"isonline": true});
    } on Exception catch (e) {
      print(e);
    }
  }

  setOnlineFalse() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'))
          .update({"isonline": false});
    } on Exception catch (e) {
      print(e);
    }
  }

  getMembers() async {
    List data = [];
    var res = await FirebaseFirestore.instance
        .collection('members')
        .where("project_id", isEqualTo: project_id.value)
        .get();
    var members = res.docs;
    for (var i = 0; i < members.length; i++) {
      var user = await members[i]['user'].get();
      Map map = {
        "id": user.id,
        "isonline": user.get('isonline'),
        "contactno": user.get('contactno'),
        "email": user.get('email'),
        "fcmToken": user.get('fcmToken') ?? "",
        "firstname": user.get('firstname'),
        "lastname": user.get('lastname'),
        "image": user.get('image') == ""
            ? "https://firebasestorage.googleapis.com/v0/b/taskmanagement-45a52.appspot.com/o/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg?alt=media&token=afbc6a11-a050-42a6-8f7b-07f236de02cb"
            : user.get('image'),
      };
      data.add(map);
    }
    membersList.assignAll(await membersFromJson(jsonEncode(data)));
    membersList.removeWhere((element) =>
        element.id == Get.find<StorageServices>().storage.read('id'));
  }

  getListenToChats() async {
    try {
      streamChats = await FirebaseFirestore.instance
          .collection('chats')
          .where("groupid", isEqualTo: project_id.value)
          .limit(100)
          .snapshots();

      listener = streamChats!.listen((event) async {
        List data = [];
        for (var chats in event.docs) {
          var userDetails = await chats['senderdetails'].get();
          var userObj = await userDetails.data();
          userObj['id'] = userDetails.id;
          var elementData = {
            "id": chats.id,
            "senderdetails": userObj,
            "senderid": chats['senderid'],
            "chat": chats['chat'],
            "isText": chats['isText'],
            "seenby": chats['seenby'],
            "datecreated": chats['datecreated'].toDate().toString()
          };
          data.add(elementData);
        }
        chatList.assignAll(await chatsFromJson(jsonEncode(data)));
        chatList.sort((a, b) => a.datecreated.compareTo(b.datecreated));
        Future.delayed(Duration(seconds: 1), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  sendChat({required String message}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));
      await FirebaseFirestore.instance.collection('chats').add({
        "chat": message,
        "senderid": Get.find<StorageServices>().storage.read('id'),
        "senderdetails": userDocumentReference,
        "datecreated": DateTime.now(),
        "isText": true,
        "groupid": project_id.value,
        "seenby": [Get.find<StorageServices>().storage.read('firstname')]
      });
      Future.delayed(Duration(seconds: 1), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      await getMembers();
      for (var i = 0; i < membersList.length; i++) {
        if (membersList[i].isonline == false && membersList[i].fcmToken != "") {
          Get.find<NotificationServices>().sendNotification(
              userToken: membersList[i].fcmToken,
              bodymessage:
                  "${Get.find<StorageServices>().storage.read('firstname')}: $message",
              subtitle: "",
              title: "${project_name.value} Group Message");
        } else {
          print("online");
        }
      }
    } catch (e) {}
  }
}

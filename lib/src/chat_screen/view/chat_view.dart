import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/services/getstorage_services.dart';
import 'package:tm/src/chat_screen/controller/chat_controller.dart';
import 'package:intl/intl.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20.sp,
              color: Colors.black,
            ),
          ),
          title: Text("Chat"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.chatList.length,
                      shrinkWrap: true,
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 14,
                                right: 14,
                                top: 10,
                              ),
                              child: Align(
                                alignment:
                                    (controller.chatList[index].senderid !=
                                            Get.find<StorageServices>()
                                                .storage
                                                .read('id')
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (controller
                                                .chatList[index].senderid !=
                                            Get.find<StorageServices>()
                                                .storage
                                                .read('id')
                                        ? Colors.grey.shade200
                                        : Color.fromARGB(255, 247, 235, 217)),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      controller.chatList[index].senderid !=
                                              Get.find<StorageServices>()
                                                  .storage
                                                  .read('id')
                                          ? Column(
                                              children: [
                                                Text(
                                                  controller.chatList[index]
                                                      .senderdetails.firstname,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                )
                                              ],
                                            )
                                          : SizedBox(),
                                      Text(
                                        controller.chatList[index].chat,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 7.w,
                                right: 7.w,
                              ),
                              child: Align(
                                  alignment:
                                      (controller.chatList[index].senderid !=
                                              Get.find<StorageServices>()
                                                  .storage
                                                  .read('id')
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: Text(
                                    DateFormat('yMMMd').format(controller
                                            .chatList[index].datecreated) +
                                        " " +
                                        DateFormat('jm').format(controller
                                            .chatList[index].datecreated) +
                                        ", " +
                                        DateFormat('E').format(controller
                                            .chatList[index].datecreated),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 9.sp),
                                  )),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 10.h,
                padding: EdgeInsets.only(bottom: 2.h, left: 3.w, right: 3.w),
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.black, width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 5.h,
                      width: 85.w,
                      child: TextField(
                        controller: controller.message,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Type something..'),
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          await controller.sendChat(
                              message: controller.message.text);
                          controller.message.clear();
                        },
                        child: Icon(Icons.send))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

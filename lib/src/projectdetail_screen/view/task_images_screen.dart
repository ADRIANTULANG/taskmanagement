import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/services/getstorage_services.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TaskImages extends GetView<ProjectDetailController> {
  const TaskImages(
      {super.key,
      required this.images,
      required this.email,
      required this.documentID});
  final RxList images;
  final String email;
  final String documentID;

  @override
  Widget build(BuildContext context) {
    int current_index = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Images"),
        actions: [
          InkWell(
              onTap: () {
                if (email ==
                    Get.find<StorageServices>().storage.read('email')) {
                  controller.pickImageFromImageScreen(documentID: documentID);
                } else {
                  Get.snackbar("Message", "Only assignee can upload image");
                }
              },
              child: Icon(Icons.upload_file)),
          SizedBox(
            width: 2.w,
          ),
          InkWell(
              onTap: () {
                if (email ==
                    Get.find<StorageServices>().storage.read('email')) {
                  controller.deleteImageFromTask(
                      images: images,
                      documentID: documentID,
                      imageLink: images[current_index]);
                } else {
                  Get.snackbar("Message", "Only assignee can delete image");
                }
              },
              child: Icon(Icons.delete)),
          SizedBox(
            width: 2.w,
          ),
          InkWell(
              onTap: () {
                controller.downloadImageFile(
                    link: images[current_index],
                    context: context,
                    filename: "Task_Management_Image");
              },
              child: Icon(Icons.download)),
          SizedBox(
            width: 5.w,
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          return Obx(
            () => CarouselSlider(
              options: CarouselOptions(
                height: 100.h,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                // autoPlay: false,
                onPageChanged: (index, reason) {
                  current_index = index;
                  print(current_index);
                },
              ),
              items: images
                  .map((item) => Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            child: Center(
                                child: Image.network(
                              item,
                              fit: BoxFit.fitWidth,
                              height: 100.h,
                            )),
                          ),
                          Positioned(
                            child: Obx(
                              () => controller.isDownloadingImage.value
                                  ? CircularPercentIndicator(
                                      radius: 8.w,
                                      lineWidth: 1.w,
                                      animation: true,
                                      percent: controller.progressImage.value,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.white,
                                    )
                                  : SizedBox(),
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

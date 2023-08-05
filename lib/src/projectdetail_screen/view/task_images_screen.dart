import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TaskImages extends GetView<ProjectDetailController> {
  const TaskImages({super.key, required this.images});
  final List images;

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
          return CarouselSlider(
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
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.white,
                                  )
                                : SizedBox(),
                          ),
                        )
                      ],
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

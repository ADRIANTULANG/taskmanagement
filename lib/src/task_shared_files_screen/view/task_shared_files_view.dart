import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../services/colors_services.dart';
import '../controller/task_shared_files_controller.dart';

class TaskSharedFilesView extends GetView<TaskSharedFilesController> {
  const TaskSharedFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskSharedFilesController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Files"),
        backgroundColor: ColorServices.dirtywhite,
      ),
      body: Container(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h),
          child: Obx(
            () => GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.88,
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 1.h),
              itemCount: controller.filesList.length,
              itemBuilder: (BuildContext context, int index) {
                return controller.filesList[index].type == "image"
                    ? Container(
                        height: 20.h,
                        width: 40.w,
                        child: Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(controller
                                              .filesList[index].url))),
                                ),
                                Positioned(
                                  child: Obx(
                                    () => controller.filesList[index]
                                                .isDownloading.value ==
                                            false
                                        ? SizedBox()
                                        : Obx(
                                            () => CircularPercentIndicator(
                                              radius: 8.w,
                                              lineWidth: 1.w,
                                              animation: true,
                                              percent: controller
                                                  .filesList[index]
                                                  .progress
                                                  .value,
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              progressColor:
                                                  ColorServices.dirtywhite,
                                            ),
                                          ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                left: 3.w,
                              ),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.filesList[index].name,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.sp),
                                        ),
                                        Text(
                                          DateFormat('yMMMd').format(controller
                                                  .filesList[index]
                                                  .datecreated) +
                                              " " +
                                              DateFormat('jm').format(controller
                                                  .filesList[index]
                                                  .datecreated),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 8.sp),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Padding(
                                    padding: EdgeInsets.only(right: 1.w),
                                    child: InkWell(
                                        onTap: () {
                                          print("Called");
                                          controller.downloadFile(
                                              link: controller
                                                  .filesList[index].url,
                                              index: index,
                                              context: context,
                                              filename: controller
                                                  .filesList[index].name);
                                        },
                                        child: Icon(Icons.download)),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ))
                    : Column(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: 17.h,
                                width: 100.w,
                                child: Image.asset(
                                    "assets/images/${controller.filesList[index].name.split('.')[1]}.png"),
                              ),
                              Positioned(
                                child: Obx(
                                  () => controller.filesList[index]
                                              .isDownloading.value ==
                                          false
                                      ? SizedBox()
                                      : Obx(
                                          () => CircularPercentIndicator(
                                            radius: 8.w,
                                            lineWidth: 1.w,
                                            animation: true,
                                            percent: controller.filesList[index]
                                                .progress.value,
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            progressColor:
                                                ColorServices.dirtywhite,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(
                              left: 3.w,
                            ),
                            decoration: BoxDecoration(border: Border.all()),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.filesList[index].name,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.sp),
                                      ),
                                      Text(
                                        DateFormat('yMMMd').format(controller
                                                .filesList[index].datecreated) +
                                            " " +
                                            DateFormat('jm').format(controller
                                                .filesList[index].datecreated),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 8.sp),
                                      ),
                                    ],
                                  ),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(right: 1.w),
                                  child: InkWell(
                                      onTap: () {
                                        controller.downloadFile(
                                            link:
                                                controller.filesList[index].url,
                                            index: index,
                                            context: context,
                                            filename: controller
                                                .filesList[index].name);
                                      },
                                      child: Icon(Icons.download)),
                                )
                              ],
                            ),
                          ))
                        ],
                      );
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorServices.dirtywhite,
        onPressed: () {
          controller.pickFilesThenUpload();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

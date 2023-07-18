import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/services/getstorage_services.dart';
import 'package:tm/src/projectdetail_screen/botomsheets/projectdetail_bottomsheet.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';
import 'package:tm/src/projectdetail_screen/view/shared_resources.dart';
import '../../../services/colors_services.dart';
import '../alertdialog/projectdetail_alertdialog.dart';
import 'create_task_screen.dart';
import 'package:intl/intl.dart';

class ProjectDetailView extends GetView<ProjectDetailController> {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProjectDetailController());
    return Obx(
      () => controller.isLoading.value == true
          ? Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: ColorServices.dirtywhite,
                  size: 40.sp,
                ),
              ),
            )
          : Scaffold(
              body: SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 30.h,
                          width: 100.w,
                          child: Image(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(controller.project_image.value)),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                ),
                                child: Text(
                                  controller.project_name.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: 5.w,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    Get.to(() => SharedResourcesView());
                                  },
                                  child: Icon(Icons.folder)),
                            ),
                            Get.find<StorageServices>().storage.read('id') ==
                                    controller.ownerid.value
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      right: 5.w,
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          ProjectDetailBottomSheet
                                              .showAddMembers(
                                                  controller: controller);
                                        },
                                        child: Icon(Icons.person_add)),
                                  )
                                : SizedBox()
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          width: 100.w,
                          child: Text(
                            controller.date_created.value,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Container(
                                height: 8.h,
                                width: 100.w,
                              ),
                              for (var stackindex = 0;
                                  stackindex <
                                      (controller.membersList.length > 5
                                          ? 4
                                          : controller.membersList.length);
                                  stackindex++) ...[
                                Positioned(
                                    left: (stackindex.sp * 18),
                                    child: Container(
                                      height: 5.h,
                                      width: 10.w,
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(controller
                                                  .membersList[stackindex]
                                                  .image))),
                                    )),
                                controller.membersList.length > 5
                                    ? Positioned(
                                        left: ((controller.membersList.length) *
                                            17),
                                        child: Container(
                                          child: Text(
                                              (controller.membersList.length -
                                                          5)
                                                      .toString() +
                                                  "+"),
                                        ),
                                      )
                                    : SizedBox()
                              ]
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          width: 100.w,
                          child: Text(
                            "Task",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.taskList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Container(
                                  width: 100.w,
                                  color: ColorServices.dirtywhite,
                                  padding: EdgeInsets.only(
                                      top: 2.h,
                                      bottom: 1.h,
                                      left: 2.w,
                                      right: 2.w),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("For:"),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(controller.taskList[index]
                                                    .userDetails.email),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          controller.taskList[index].task,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13.sp),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        controller.taskList[index].images
                                                    .length ==
                                                0
                                            ? SizedBox()
                                            : Container(
                                                height: 15.h,
                                                width: 100.w,
                                                child: ListView.builder(
                                                  itemCount: controller
                                                      .taskList[index]
                                                      .images
                                                      .length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int imageIndex) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.w),
                                                      child: Container(
                                                        height: 15.h,
                                                        width: 30.w,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(controller
                                                                        .taskList[
                                                                            index]
                                                                        .images[
                                                                    imageIndex]))),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                        controller.taskList[index].images
                                                    .length ==
                                                0
                                            ? SizedBox()
                                            : SizedBox(
                                                height: 2.h,
                                              ),
                                        Row(
                                          children: [
                                            Text("Status: "),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              controller.taskList[index].status,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Deadline: "),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              DateFormat('yMMMd').format(
                                                  controller.taskList[index]
                                                      .deadline),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            PopupMenuButton(
                                              onSelected: (value) {
                                                if (controller.ownerid.value ==
                                                        Get.find<
                                                                StorageServices>()
                                                            .storage
                                                            .read('id') ||
                                                    Get.find<StorageServices>()
                                                            .storage
                                                            .read('email') ==
                                                        controller
                                                            .taskList[index]
                                                            .userDetails
                                                            .email) {
                                                  controller.updateTask(
                                                      documentID: controller
                                                          .taskList[index].id,
                                                      status: value);
                                                } else {
                                                  Get.snackbar("Message",
                                                      "Only project leader and the assignee can update this task.",
                                                      backgroundColor:
                                                          ColorServices
                                                              .dirtywhite);
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return [
                                                  PopupMenuItem(
                                                      value: "Ongoing",
                                                      child: Text("Ongoing")),
                                                  PopupMenuItem(
                                                      value: "Completed",
                                                      child: Text("Completed")),
                                                ];
                                              },
                                              child: Container(
                                                height: 5.h,
                                                width: 10.w,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Icon(
                                                    Icons.checklist_rounded),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (Get.find<StorageServices>()
                                                        .storage
                                                        .read('email') ==
                                                    controller.taskList[index]
                                                        .userDetails.email) {
                                                  controller.pickImage(
                                                      documentID: controller
                                                          .taskList[index].id);
                                                } else {
                                                  Get.snackbar("Message",
                                                      "Only the assignee can update this task.",
                                                      backgroundColor:
                                                          ColorServices
                                                              .dirtywhite);
                                                }
                                              },
                                              child: Container(
                                                height: 5.h,
                                                width: 10.w,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child:
                                                    Icon(Icons.image_outlined),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                ProjectDetailAlertDialog
                                                    .showCommentSomething(
                                                        documentID: controller
                                                            .taskList[index].id,
                                                        controller: controller);
                                              },
                                              child: Container(
                                                height: 5.h,
                                                width: 10.w,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Icon(Icons
                                                    .messenger_outline_sharp),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        controller.taskList[index].comment
                                                    .length ==
                                                0
                                            ? SizedBox()
                                            : Text(
                                                "Comments",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                        Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: controller
                                                .taskList[index].comment.length,
                                            itemBuilder: (BuildContext context,
                                                int commentIndex) {
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1.5.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "From: " +
                                                          controller
                                                              .taskList[index]
                                                              .comment[
                                                                  commentIndex]
                                                              .split('||')[1],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 9.sp),
                                                    ),
                                                    Text(
                                                      "Comment: " +
                                                          controller
                                                              .taskList[index]
                                                              .comment[
                                                                  commentIndex]
                                                              .split('||')[0],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 9.sp),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ]),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorServices.dirtywhite,
                onPressed: () {
                  Get.to(() => CreateTaskView());
                },
                child: Icon(Icons.add),
              ),
            ),
    );
  }
}

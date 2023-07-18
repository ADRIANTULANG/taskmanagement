import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/services/colors_services.dart';

import '../botomsheets/projectdetail_bottomsheet.dart';
import '../controller/projectdetail_controller.dart';

class CreateTaskView extends GetView<ProjectDetailController> {
  const CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isCreatingTask.value == true
          ? Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: ColorServices.dirtywhite,
                  size: 40.sp,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: ColorServices.dirtywhite,
                title: Text("New Task"),
              ),
              body: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      height: 20.h,
                      width: 100.w,
                      child: TextField(
                        maxLength: 300,
                        maxLines: 20,
                        controller: controller.task,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                EdgeInsets.only(left: 3.w, top: 2.h),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3)),
                            hintText: 'Write something about the task.'),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      width: 100.w,
                      child: Text(
                        "Deadline",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: InkWell(
                        onTap: () {
                          ProjectDetailBottomSheet.showDate(
                              controller: controller);
                        },
                        child: Container(
                            padding: EdgeInsets.only(
                              left: 2.w,
                            ),
                            height: 6.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(width: 0.8)),
                            alignment: Alignment.centerLeft,
                            child: Obx(
                              () => Text(
                                controller.deadline.value == ''
                                    ? "Select Date"
                                    : controller.deadline.value,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.grey),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      width: 100.w,
                      child: Text(
                        "Assign to",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      height: 7.h,
                      width: 100.w,
                      child: TextField(
                        controller: controller.search,
                        onChanged: (value) {
                          if (controller.debounce?.isActive ?? false)
                            controller.debounce!.cancel();
                          controller.debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            controller.searchMembers(keyword: value);
                            FocusScope.of(context).unfocus();
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                EdgeInsets.only(left: 3.w, top: 2.h),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3)),
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: Colors.grey),
                            hintText: 'Search email here.'),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: ListView.builder(
                          itemCount: controller.membersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 5.h,
                                        width: 10.w,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(controller
                                                    .membersList[index]
                                                    .image))),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        controller.membersList[index].email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Checkbox(
                                        activeColor: ColorServices.dirtywhite,
                                        value: controller.membersList[index]
                                            .isSelected.value,
                                        onChanged: (value) {
                                          for (var i = 0;
                                              i < controller.membersList.length;
                                              i++) {
                                            if (controller.membersList[i].id ==
                                                controller
                                                    .membersList[index].id) {
                                              controller.membersList[i]
                                                  .isSelected.value = value!;
                                            } else {
                                              controller.membersList[i]
                                                  .isSelected.value = false;
                                            }
                                          }
                                          for (var i = 0;
                                              i <
                                                  controller
                                                      .membersList_masterList
                                                      .length;
                                              i++) {
                                            if (controller
                                                    .membersList_masterList[i]
                                                    .id ==
                                                controller
                                                    .membersList[index].id) {
                                              controller
                                                  .membersList_masterList[i]
                                                  .isSelected
                                                  .value = value!;
                                            } else {
                                              controller
                                                  .membersList_masterList[i]
                                                  .isSelected
                                                  .value = false;
                                            }
                                          }
                                        }),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 1.h),
                child: SizedBox(
                  width: 100.w,
                  height: 7.h,
                  child: ElevatedButton(
                      child: Text("Create Task",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black)),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorServices.dirtywhite),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () {
                        if (controller.deadline.value != '' &&
                            controller.task.text.isNotEmpty) {
                          controller.createTask();
                        }
                      }),
                ),
              ),
            ),
    );
  }
}

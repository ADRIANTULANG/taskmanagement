import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/src/home_screen/controller/home_controller.dart';

import '../../../services/colors_services.dart';
import '../controller/create_project_controller.dart';

class CreateProjectView extends GetView<CreateProjectController> {
  const CreateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreateProjectController());
    return Obx(
      () => controller.isCreatingProject.value == true
          ? Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: ColorServices.black,
                  size: 40.sp,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: ColorServices.dirtywhite,
                centerTitle: true,
                title: Text(
                  "Create Projects",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.only(top: 4.h, left: 5.w, right: 5.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        InkWell(
                          onTap: () {
                            controller.pickProjectImage();
                          },
                          child: Obx(
                            () => controller.filePath.value == ""
                                ? Container(
                                    height: 25.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(Icons.image),
                                  )
                                : Container(
                                    height: 25.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(
                                                controller.filePath.value))),
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 7.h,
                          width: 100.w,
                          child: TextField(
                            controller: controller.name,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.only(left: 3.w),
                                alignLabelWithHint: false,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                hintText: 'Project Name'),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Project Members",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          child: Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  Get.find<HomeController>().userList.length,
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
                                            height: 6.h,
                                            width: 10.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(Get.find<
                                                            HomeController>()
                                                        .userList[index]
                                                        .image))),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            Get.find<HomeController>()
                                                .userList[index]
                                                .email,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11.sp),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () => Checkbox(
                                            value: Get.find<HomeController>()
                                                .userList[index]
                                                .isSelected
                                                .value,
                                            onChanged: (val) {
                                              Get.find<HomeController>()
                                                  .userList[index]
                                                  .isSelected
                                                  .value = val!;
                                            }),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
                child: SizedBox(
                  width: 100.w,
                  height: 7.h,
                  child: ElevatedButton(
                      child: Text("Create Project",
                          style: TextStyle(
                              fontSize: 14.sp, color: ColorServices.black)),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorServices.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.white)))),
                      onPressed: () {
                        controller.createProject();
                      }),
                ),
              ),
            ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';

import '../../../services/colors_services.dart';

class UpdateProjectView extends GetView<ProjectDetailController> {
  const UpdateProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isUpdatingProject.value == true
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
                  "Update Project",
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
                            () => controller.updatefilePath.value == ""
                                ? Container(
                                    height: 25.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(controller
                                                .project_image.value))),
                                  )
                                : Container(
                                    height: 25.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(controller
                                                .updatefilePath.value))),
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
                            controller: controller.updateprojectname,
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
                      ],
                    ),
                  )),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
                child: SizedBox(
                  width: 100.w,
                  height: 7.h,
                  child: ElevatedButton(
                      child: Text("Update Project",
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
                        if (controller.updateprojectname.text.isNotEmpty) {
                          controller.updateProject();
                        }
                      }),
                ),
              ),
            ),
    );
  }
}

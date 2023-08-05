import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/services/colors_services.dart';
import 'package:intl/intl.dart';
import 'package:tm/src/profile_screen/view/profile_view.dart';
import 'package:tm/src/projectdetail_screen/view/projectdetail_view.dart';
import '../../create_project_screen/view/create_project_view.dart';
import '../controller/home_controller.dart';
import '../widget/home_alertdialogs.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.to(() => ProfileView());
              },
              child: Icon(Icons.person)),
          backgroundColor: ColorServices.dirtywhite,
          centerTitle: true,
          title: Text(
            "My Projects",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
          ),
          actions: [
            InkWell(
                onTap: () {
                  HomeAlertDialogs.showLogoutDialog();
                },
                child: Icon(Icons.logout)),
            SizedBox(
              width: 5.w,
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
          child: Obx(
            () => ListView.builder(
              itemCount: controller.projectList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: InkWell(
                    onTap: () async {
                      Get.to(() => ProjectDetailView(), arguments: {
                        "project_id": controller.projectList[index].id,
                        "project_name": controller.projectList[index].name,
                        "project_image": controller.projectList[index].image,
                        "ownerid": controller.projectList[index].ownerid,
                        "date_created": DateFormat('yMMMd').format(
                                controller.projectList[index].datecreated) +
                            " " +
                            DateFormat('jm').format(
                                controller.projectList[index].datecreated),
                      });
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 17.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        controller.projectList[index].image)),
                                border: Border.all(),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                          ),
                          Container(
                            height: 8.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                color: ColorServices.white,
                                border: Border.all(),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                      left: 2.w, top: 1.h, right: 2.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.projectList[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.sp),
                                      ),
                                      Text(
                                        DateFormat('yMMMd').format(controller
                                                .projectList[index]
                                                .datecreated) +
                                            " " +
                                            DateFormat('jm').format(controller
                                                .projectList[index]
                                                .datecreated),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 9.sp),
                                      ),
                                    ],
                                  ),
                                )),
                                // Expanded(
                                //     child: Container(
                                //   padding: EdgeInsets.only(right: 2.w),
                                //   alignment: Alignment.centerRight,
                                //   child: Icon(Icons.more_vert),
                                // ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorServices.dirtywhite,
          onPressed: () {
            Get.to(() => CreateProjectView());
          },
          child: Icon(Icons.add),
        ));
  }
}

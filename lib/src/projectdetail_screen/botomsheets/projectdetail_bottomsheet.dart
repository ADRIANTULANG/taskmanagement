import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';

import '../../../services/colors_services.dart';

class ProjectDetailBottomSheet {
  static showDate({required ProjectDetailController controller}) async {
    Get.bottomSheet(Container(
      height: 40.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: SfDateRangePicker(
        enablePastDates: false,
        onSelectionChanged: controller.onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.single,
      ),
    ));
  }

  static showAddMembers({required ProjectDetailController controller}) async {
    TextEditingController textfield = TextEditingController();
    Get.bottomSheet(Container(
        height: 60.h,
        width: 100.w,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: Container(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Member",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 7.h,
                width: 100.w,
                child: TextField(
                  controller: textfield,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 3.w),
                      alignLabelWithHint: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3)),
                      hintText: 'Search email'),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: controller.allUsersNotMember.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              .allUsersNotMember[index]
                                              .image))),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  controller.allUsersNotMember[index].email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                            Obx(
                              () => Checkbox(
                                  activeColor: ColorServices.dirtywhite,
                                  value: controller.allUsersNotMember[index]
                                      .isSelected.value,
                                  onChanged: (value) {
                                    controller.allUsersNotMember[index]
                                        .isSelected.value = value!;
                                  }),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 7.h,
                child: ElevatedButton(
                    child: Text("ADD",
                        style: TextStyle(fontSize: 18.sp, color: Colors.black)),
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
                      controller.addMembers();
                    }),
              ),
              SizedBox(
                height: 2.h,
              )
            ],
          ),
        )));
  }
}

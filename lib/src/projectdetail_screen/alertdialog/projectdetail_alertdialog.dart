import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';

import '../../../services/colors_services.dart';

class ProjectDetailAlertDialog {
  static showCommentSomething(
      {required ProjectDetailController controller,
      required String documentID}) async {
    TextEditingController comment = TextEditingController();
    Get.dialog(AlertDialog(
        content: Container(
      height: 30.h,
      width: 100.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Say something",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.black),
          ),
          SizedBox(
            height: 3.5.h,
          ),
          Container(
            height: 15.h,
            width: 100.w,
            child: TextField(
              controller: comment,
              maxLength: 300,
              maxLines: 10,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2)),
                  hintText: 'Comment'),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          SizedBox(
            width: 100.w,
            height: 7.h,
            child: ElevatedButton(
                child: Text("Comment",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(ColorServices.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)))),
                onPressed: () {
                  controller.commentToTask(
                      documentID: documentID, comment: comment.text);
                }),
          )
        ],
      ),
    )));
  }

  static deleteProject(
      {required ProjectDetailController controller,
      required String documentID}) async {
    Get.dialog(AlertDialog(
        content: Container(
      height: 18.h,
      width: 100.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Are you sure you want to delete this project ?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: Colors.black),
          ),
          SizedBox(
            height: 3.5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    controller.deleteProject(documentID: documentID);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ))
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    )));
  }

  static deleteTask(
      {required ProjectDetailController controller,
      required String documentID}) async {
    Get.dialog(AlertDialog(
        content: Container(
      height: 18.h,
      width: 100.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Are you sure you want to delete this task ?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: Colors.black),
          ),
          SizedBox(
            height: 3.5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    // controller.deleteProject(documentID: documentID);
                    controller.deleteTask(documentID: documentID);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ))
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    )));
  }
}

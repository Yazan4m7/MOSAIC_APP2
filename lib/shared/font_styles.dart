import 'package:flutter/material.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyFontStyles {
  static TextStyle textHeadingFontStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline1.copyWith(
        fontFamily: "montserrat", fontSize: 43.0.sp, fontWeight: FontWeight.bold, color: Colors.black87);
  }
  static TextStyle textValueheadingFontStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline1.copyWith(
        fontFamily: "montserrat", fontSize: 43.0.sp,fontWeight: FontWeight.w400, color: Colors.black87);
  }
  static TextStyle titleBlackFontStyle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .headline1
        .copyWith(
      fontFamily: "montserrat",
      fontSize: Responsiveness.appBarTitleFontSize,
      letterSpacing: 0,

      fontWeight: FontWeight.w600,
      color: Colors.black,);
  }
  static TextStyle valueFontStyle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .headline1
        .copyWith(
      fontFamily: "montserrat",
      fontSize: 43.0.sp,
      fontWeight: FontWeight.w400,
      color: Colors.black,);
  }
  static TextStyle statementEntryFontStyle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .headline1
        .copyWith(

      fontFamily: "droid",
      fontSize: Responsiveness.entryFontSize.sp,
      fontWeight: FontWeight.w400,
      color: Colors.black,);
  }
  static TextStyle statementHeaderFontStyle(BuildContext context) {
    return TextStyle(
      fontSize: Responsiveness.entryFontSize.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }
  static TextStyle statementPatientNameFontStyle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .headline1
        .copyWith(
      fontFamily: "droid",
      fontSize: Responsiveness.patientNameFontSize.sp,
      fontWeight: FontWeight.w400,
      color: Colors.black,);
  }
  static TextStyle textFieldsLabelStyle(BuildContext context){
    return Theme.of(context).textTheme.headline1.copyWith(
        fontSize: 43.0.sp,
        fontWeight: FontWeight.bold,
        color: Colors.grey);



  }
  static TextStyle doctorNameFontStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline1.copyWith(
        fontFamily: "droid", fontSize:Responsiveness.docNameFontSize, fontWeight: FontWeight.bold, color: Color(0xff333333));
  }


}

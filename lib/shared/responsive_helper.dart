import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';

/*
  Centralized class for font sizes and to not let screen util resize while using application
 */
class Responsiveness {
  static double? docNameFontSize;
  static late double logoWidth;
  static double? entryFontSize;
  static double? patientNameFontSize;
  static double? mainNavCardsFontSize;
  static double? appBarTitleFontSize;
  static double? dialogTitleFontSize;
  static double? dialogTextFontSize;
  static setResponsiveProperties() {
    dialogTitleFontSize = 53.0.sp;
    dialogTextFontSize = 40.0.sp;
    appBarTitleFontSize = 52.0.sp;
    docNameFontSize = 55.0.sp;
    logoWidth = 480.0;
    mainNavCardsFontSize = 51.0.sp;
    if (!Global.prefs!.containsKey('entryFontSize'))
      entryFontSize = 37.0;
    else
      entryFontSize = Global.prefs!.getDouble('entryFontSize');
    if (!Global.prefs!.containsKey('patientNameFontSize'))
      patientNameFontSize = 32.0;
    else
      patientNameFontSize = Global.prefs!.getDouble('patientNameFontSize');

//    }else if (screenWidth >= 600){
//      docNameFontSize = 31.0;
//      logoWidth = 230.0;
//      entryFontSize = 15.0;
//      patientNameFontSize = 13.0;
//    }
  }

  static increaseSize() {
    entryFontSize = entryFontSize! - 1;
    patientNameFontSize = patientNameFontSize! - 1;
    Global.prefs!.setDouble("entryFontSize", entryFontSize!);
    Global.prefs!.setDouble("patientNameFontSize", patientNameFontSize!);
  }

  static decreaseSize() {
    entryFontSize = entryFontSize! - 1;
    patientNameFontSize = patientNameFontSize! - 1;
    Global.prefs!.setDouble("entryFontSize", entryFontSize!);
    Global.prefs!.setDouble("patientNameFontSize", patientNameFontSize!);
  }
}

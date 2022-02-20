import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

main() async {
  runApp(
    MaterialApp(
      home: Scaffold(body: EntryPoint()),
    ),
  );
}

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 1920),
      builder: () => MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                style: TextStyle(fontSize: 180.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

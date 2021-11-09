import 'package:flutter/material.dart';
import 'package:mosaic_doctors/services/feedbackService.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:reviews_slider/reviews_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackView extends StatefulWidget {
  String? caseId;
  String? patientName;
  String? doctorId;
  FeedbackView({this.caseId, this.patientName, this.doctorId});
  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  String feedbackDetails = "";
  int rating = -1;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SharedWidgets.getAppBarUI(
                context,
                _scaffoldKey as GlobalKey<ScaffoldState>,
                "Provide Feedback",
              ),
              Center(
                child: Row(children: [
                  Container(
                padding: const EdgeInsets.only(
                    left: 5.0),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: Text(
                        " Patient Name: ",
                        style: MyFontStyles.textHeadingFontStyle(context)
                            .copyWith(fontSize: 17),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: Text(
                      widget.patientName ?? "N/A",
                      style: MyFontStyles.doctorNameFontStyle(context)
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 150.h),
                ]),
              ),
              ReviewSlider(
                  initialValue: 4,
                  options: ['Terrible', 'Bad', 'Okay', 'Good', 'Great'],
                  onChange: (int value) {
                    rating = value;
                    print(value);
                  }),
              Container(
                  margin: EdgeInsets.all(20),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Details (Optional)',
                    ),
                    onChanged: (text) {
                      feedbackDetails = text;
                      //you can access nameController in its scope to get
                      // the value of text entered as shown below
                      //fullName = nameController.text;
                    },
                  )),
              FlatButton(
                color: Colors.black87,
                onPressed: () async {
                  FeedbackService.registerFeedback(widget.caseId, rating,
                      feedbackDetails, widget.patientName, widget.doctorId);
                  SharedWidgets.showMOSAICDialog(
                      "Thank you!", context, 'Success', () {
                    Navigator.pop(context);
                  });
                },
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "SEND",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mosaic_doctors/services/exCasesController.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mosaic_doctors/views/labStatementMainScreen.dart';
import 'package:path/path.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formsPageViewController = PageController();
  late List _forms;
  TextEditingController patientName = TextEditingController();
  TextEditingController dateIn = TextEditingController();
  TextEditingController dateReturn = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController jobNo = TextEditingController();
  TextEditingController stumpShade = TextEditingController();
  TextEditingController vitaClassic = TextEditingController();
  TextEditingController master3D = TextEditingController();
  int? translucency = -1;
  int? surfaceTexture = -1;
  bool studyModels = false;
   static GroupController enclosedItems =  GroupController(
    isMultipleSelection: true,

  );
  static  GroupController miscellaneous = GroupController(
    isMultipleSelection: true,
  );
  static GroupController prosthetics = GroupController(
    isMultipleSelection: true,
  );
  static GroupController crownBridgeMetalFree = GroupController(
    isMultipleSelection: true,
  );
  static GroupController crownBridgeMetalRestoration = GroupController(
    isMultipleSelection: true,
  );
  static GroupController implantWorkMetalFree = GroupController(
    isMultipleSelection: true,
  );
  static GroupController implantWorkMetalRestoration = GroupController(
    isMultipleSelection: true,
  );
  static GroupController implantWorkAllOn46 = GroupController(
    isMultipleSelection: true,
  );
  static GroupController selectedUnitsUR = GroupController(
    isMultipleSelection: true,
  );
  static GroupController selectedUnitsUL = GroupController(
    isMultipleSelection: true,
  );
  static GroupController selectedUnitsLL = GroupController(
    isMultipleSelection: true,
  );
  static GroupController selectedUnitsLR = GroupController(
    isMultipleSelection: true,
  );
  DateTime selectedDate = DateTime.now();
  int currentPage = 0;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  Color expandableColor = Colors.black87;
  String currentCaseId = "null";
  late File selectedfile;
  late Response response;
  String? progress;
  Dio dio = new Dio();
  bool uploadedAFile = false;
  String? filePathOnServer = "null";

  @override
  void initState() {
    super.initState();

    /// Attach a listener which will update the state and refresh the page index
    _formsPageViewController.addListener(() {
      if (_formsPageViewController.page!.round() != currentPage) {
        setState(() {
          currentPage = _formsPageViewController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
   // _formsPageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height - 350.h;

    _forms = [
      WillPopScope(
          onWillPop: () => Future.sync(this.onWillPop),
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Scaffold(
              body: _caseDetails1(context),
            ),
          )),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Scaffold(
            body: _caseDetails2(context),
          ),
        ),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Scaffold(
            body: _caseDetails3(context),
          ),
        ),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Scaffold(
            body: _teethSelection(context),
          ),
        ),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Scaffold(
            body: _attachments(context),
          ),
        ),
      ),
    ];

    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', 'US')],
      home: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(100.0), // here the desired height
                child: SharedWidgets.getAppBarUI(
                    context,
                    _scaffoldKey as GlobalKey<ScaffoldState>,
                    "NEW CASE WIZARD (${currentPage + 1}/5)",
                    null,
                    null,
                    Colors.white,
                    0.3)),
            resizeToAvoidBottomInset: false,
            body: Stack(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 50,
                  child: PageView.builder(
                    controller: _formsPageViewController,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      currentPage = index;
                      return Stack(
                        children: [
                          SingleChildScrollView(child: _forms[index]),
                          isKeyboardVisible
                              ? SizedBox()
                              : _bottomNavBar(context)
                        ],
                      );
                      // return _forms[index];
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 12)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero))),
                    ),
                    onPressed: () {
                      _previousFormStep();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigate_before),
                        currentPage == 0
                            ? Text(
                                "Cancel",
                                style: TextStyle(fontSize: 50.sp),
                              )
                            : Text(
                                "Back",
                                style: TextStyle(fontSize: 50.sp),
                              ),
                      ],
                    ))),
            SizedBox(
                // width: 3,
                ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12)),
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero))),
                ),
                onPressed: () async {
                  print("Current Page : $currentPage");
                  if (currentPage < 4)
                    _nextFormStep();
                  else
                    SharedWidgets.showMOSAICDialog(
                        "Case Created Successfully", context, "SUCCESS", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LabStatementMainScreen()));
                    });
                  if (currentPage == 3) {
                    currentCaseId = await ExternalCasesController.createCase(
                        patientName.text,
                        address.text,
                        dateIn.text,
                        dateReturn.text,
                        tel.text,
                        email.text,
                        jobNo.text,
                        stumpShade.text,
                        vitaClassic.text,
                        master3D.text,
                        translucency.toString(),
                        surfaceTexture.toString(),
                        enclosedItems.selectedItem,
                        miscellaneous.selectedItem,
                        prosthetics.selectedItem,
                        crownBridgeMetalFree.selectedItem,
                        crownBridgeMetalRestoration.selectedItem,
                        implantWorkMetalFree.selectedItem,
                        implantWorkMetalRestoration.selectedItem,
                        implantWorkAllOn46.selectedItem,
                        selectedUnitsUL.selectedItem,
                        selectedUnitsUR.selectedItem,
                        selectedUnitsLL.selectedItem,
                        selectedUnitsLR.selectedItem);
                    if (currentCaseId == 'null') return;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    currentPage < 4
                        ? Text(
                            "Next",
                            style: TextStyle(fontSize: 50.sp),
                          )
                        : Text(
                            "Finish",
                            style: TextStyle(fontSize: 50.sp),
                          ),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
setState(() {

});
    print("Enclosed: ${enclosedItems.selectedItem}");
  }

  void _previousFormStep() {
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    setState(() {

    });
    print("Enclosed: ${enclosedItems.selectedItem}");
  }

  bool onWillPop() {
    print("Enclosed: ${enclosedItems.selectedItem}");
    if (_formsPageViewController.page!.round() ==
        _formsPageViewController.initialPage) return true;
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    print("Enclosed: ${enclosedItems.selectedItem}");
    return false;
  }

  static const Color TF_BG_COLOR = Colors.white;
  Widget _caseDetails1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CASE INFORMATION 1"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: patientName,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "Patient Name",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: address,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "Address",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMMM, yyyy - hh:mm a',
                controller: dateIn,
                //initialValue: _initialValue,
                firstDate: DateTime(2021),
                lastDate: DateTime(2100),
                //icon: Icon(Icons.event),
                dateLabelText: 'Date Time',
                use24HourFormat: false,
                locale: Locale('en', 'US'),
                onChanged: (val) {
                  print(val);
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  print(val);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: TF_BG_COLOR,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: "Date In",
                  labelStyle: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMMM, yyyy - hh:mm a',
                controller: dateReturn,
                //initialValue: _initialValue,
                firstDate: DateTime(2021),
                lastDate: DateTime(2100),
                //icon: Icon(Icons.event),
                dateLabelText: 'Date Time',
                use24HourFormat: false,
                locale: Locale('en', 'US'),
                onChanged: (val) {
                  print(val);
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  print(val);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: TF_BG_COLOR,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: "Date Return",
                  labelStyle: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: tel,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 51, 204, 255),
                  ),
                ),
                labelText: "Telephone",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: email,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "E-mail",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: jobNo,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "Job no.",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _caseDetails2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CASE INFORMATION 2"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: stumpShade,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "Stump Shade",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: vitaClassic,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "Vita Classic",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: master3D,
              style: TextStyle(fontSize: 15.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: TF_BG_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(),
                ),
                labelText: "3D Master",
                labelStyle: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: ListTile(
                        minLeadingWidth: 0,
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('Low'),
                        ),
                        leading: Radio(
                          value: 1,
                          groupValue: translucency,
                          onChanged: (dynamic value) {
                            setState(() {
                              translucency = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: ListTile(
                        minLeadingWidth: 20,
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('Med'),
                        ),
                        leading: Radio(
                          value: 2,
                          groupValue: translucency,
                          onChanged: (dynamic value) {
                            setState(() {
                              translucency = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('High'),
                        ),
                        leading: Radio(
                          value: 3,
                          groupValue: translucency,
                          onChanged: (dynamic value) {
                            setState(() {
                              translucency = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 60,
                margin: EdgeInsets.fromLTRB(10, 20, 20, 10),
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 51, 204, 255), width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                ),
              ),
              Positioned(
                  left: 30,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    color: Color(0xFFFAFAFA),
                    child: Text(
                      'Translucency',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  )),
            ],
          ),
          Stack(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: ListTile(
                        minLeadingWidth: 0,
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('Low'),
                        ),
                        leading: Radio(
                          value: 1,
                          groupValue: surfaceTexture,
                          onChanged: (dynamic value) {
                            setState(() {
                              surfaceTexture = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: ListTile(
                        minLeadingWidth: 20,
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('Med'),
                        ),
                        leading: Radio(
                          value: 2,
                          groupValue: surfaceTexture,
                          onChanged: (dynamic value) {
                            setState(() {
                              surfaceTexture = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Transform.translate(
                          offset: Offset(-20, 0),
                          child: Text('High'),
                        ),
                        leading: Radio(
                          value: 3,
                          groupValue: surfaceTexture,
                          onChanged: (dynamic value) {
                            setState(() {
                              surfaceTexture = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 60,
                margin: EdgeInsets.fromLTRB(10, 20, 20, 10),
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 51, 204, 255), width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                ),
              ),
              Positioned(
                  left: 30,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    color: Color(0xFFFAFAFA),
                    child: Text(
                      'Surface Texture',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: enclosedItems,
              itemsTitle: [
                'Photos via E-mail',
                'L. Impression',
                'U. Impression',
                'Bite Registration',
                'Facebow included',
                'L. Model',
                'U. Model',
                'Implant Components',
                'Analogs'
              ],
              values: [
                'Photos via E-mail',
                'L. Impression',
                'U. Impression',
                'Bite Registration',
                'Facebow included',
                'L. Model',
                'U. Model',
                'Implant Components',
                'Analogs'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "ENCLOSED ITEMS",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: miscellaneous,
              itemsTitle: [
                'Study Models',
                'Whitening trays',
                'Articulate',
                'MouthGuard 2/3mm',
                'Essix retainer',
                'Dual Laminate',
                'Diagnostic Wax-up'
              ],
              values: [
                'Study Models',
                'Whitening trays',
                'Articulate',
                'MouthGuard 2/3mm',
                'Essix retainer',
                'Dual Laminate',
                'Diagnostic Wax-up'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "MISCELLANEOUS",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _caseDetails3(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CASE INFORMATION 3"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: prosthetics,
              itemsTitle: ['Special Tray', 'Wax tray', 'Try-in', 'Finish'],
              values: ['Special Tray', 'Wax tray', 'Try-in', 'Finish'],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "PROSTHETICS",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: crownBridgeMetalFree,
              itemsTitle: [
                'Composite Inlay/Onlay',
                'Zirconia E.max Crown',
                'Zirconia E.max Bridge',
                'Zir. Monolithic Crown',
                'Zir. Monolithic Bridge',
                'E.max Veneer',
                'E.max Crown',
                'E.max Inlay/Onlay'
              ],
              values: [
                'Composite Inlay/Onlay',
                'Zirconia E.max Crown',
                'Zirconia E.max Bridge',
                'Zir. Monolithic Crown',
                'Zir. Monolithic Bridge',
                'E.max Veneer',
                'E.max Crown',
                'E.max Inlay/Onlay'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "CROWN & BRIDGE (Metal Free): ",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: crownBridgeMetalRestoration,
              itemsTitle: [
                'Bonded Crown',
                'Bonded Bridge',
                'Gold Inlay/Onlay',
                'Maryland Wing',
                'Post and Core'
              ],
              values: [
                'Bonded Crown',
                'Bonded Bridge',
                'Gold Inlay/Onlay',
                'Maryland Wing',
                'Post and Core'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "CROWN & BRIDGE (Metal Restoration): ",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: implantWorkMetalFree,
              itemsTitle: [
                'Screw retained Crown',
                'Screw retained Bridge',
                'Cement retained Crown',
                'Cement retained Bridge'
              ],
              values: [
                'Screw retained Crown',
                'Screw retained Bridge',
                'Cement retained Crown',
                'Cement retained Bridge'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "IMPLANT WORK (Metal FREE): ",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: implantWorkMetalRestoration,
              itemsTitle: [
                'Screw retained Crown',
                'Angulated sc.ret. Crown',
                'Cement retained Crown',
                'Cement retained Bridge'
              ],
              values: [
                'Screw retained Crown',
                'Angulated sc.ret. Crown',
                'Cement retained Crown',
                'Cement retained Bridge'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "IMPLANT WORK (Metal Restoration): ",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SimpleGroupedCheckbox<String>(
              controller: implantWorkAllOn46,
              itemsTitle: [
                'Porcelain Metal Bonded',
                'Hybrid',
                'Zirconia E.max layered'
              ],
              values: [
                'Porcelain Metal Bonded',
                'Hybrid',
                'Zirconia E.max layered'
              ],
              groupStyle: GroupStyle(
                activeColor: Colors.green,
                groupTitleStyle: TextStyle(
                    color: expandableColor, fontWeight: FontWeight.bold),
              ),
              groupTitle: "IMPLANT WORK (All on 4/6): ",
              checkFirstElement: false,
              helperGroupTitle: true,
              onItemSelected: (data) {
                print(data);
              },
              isExpandableTitle: true,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _teethSelection(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("UNITS SELECTION"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SimpleGroupedCheckbox<String>(
                controller: selectedUnitsUL,
                itemsTitle: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                ],
                values: [
                  'UL1',
                  'UL2',
                  'UL3',
                  'UL4',
                  'UL5',
                  'UL6',
                  'UL7',
                  'UL8',
                ],
                groupStyle: GroupStyle(
                  activeColor: Colors.green,
                  groupTitleStyle: TextStyle(
                      color: expandableColor, fontWeight: FontWeight.bold),
                ),
                groupTitle: "UPPER LEFT ",
                checkFirstElement: false,
                helperGroupTitle: true,
                onItemSelected: (data) {
                  print(data);
                },
                isExpandableTitle: true,
              ),
              SizedBox(
                height: 25.h,
              ),
              SimpleGroupedCheckbox<String>(
                controller: selectedUnitsUR,
                itemsTitle: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                ],
                values: [
                  'UR1',
                  'UR2',
                  'UR3',
                  'UR4',
                  'UR5',
                  'UR6',
                  'UR7',
                  'UR8',
                ],
                groupStyle: GroupStyle(
                  activeColor: Colors.green,
                  groupTitleStyle: TextStyle(
                      color: expandableColor, fontWeight: FontWeight.bold),
                ),
                groupTitle: "UPPER RIGHT",
                checkFirstElement: false,
                helperGroupTitle: true,
                onItemSelected: (data) {
                  print(data);
                },
                isExpandableTitle: true,
              ),
              SizedBox(
                height: 25.h,
              ),
              SimpleGroupedCheckbox<String>(
                controller: selectedUnitsLL,
                itemsTitle: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                ],
                values: [
                  'LL1',
                  'LL2',
                  'LL3',
                  'LL4',
                  'LL5',
                  'LL6',
                  'LL7',
                  'LL8',
                ],
                groupStyle: GroupStyle(
                  activeColor: Colors.green,
                  groupTitleStyle: TextStyle(
                      color: expandableColor, fontWeight: FontWeight.bold),
                ),
                groupTitle: "LOWER LEFT UNITS",
                checkFirstElement: false,
                helperGroupTitle: true,
                onItemSelected: (data) {
                  print(data);
                },
                isExpandableTitle: true,
              ),
              SizedBox(
                height: 25.h,
              ),
              SimpleGroupedCheckbox<String>(
                controller: selectedUnitsLR,
                itemsTitle: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                ],
                values: [
                  'LR1',
                  'LR2',
                  'LR3',
                  'LR4',
                  'LR5',
                  'LR6',
                  'LR7',
                  'LR8',
                ],
                groupStyle: GroupStyle(
                  activeColor: Colors.green,
                  groupTitleStyle: TextStyle(
                      color: expandableColor, fontWeight: FontWeight.bold),
                ),
                groupTitle: "LOWER RIGHT",
                checkFirstElement: false,
                helperGroupTitle: true,
                onItemSelected: (data) {
                  print(data);
                },
                isExpandableTitle: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachments(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Upload Attachments (Optional)"),
          backgroundColor: Colors.blueAccent,
        ), //set appbar
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  //show file name here
                  child: progress == null
                      ? Text("")
                      : Text(
                          basename(progress!),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                  //show progress status here
                ),
                Container(
                    child: GestureDetector(
                  onTap: () {
                    selectFile();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.blueGrey,
                      border: Border.all(
                        color: Colors.blueGrey,
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Icon(
                          Icons.upload_outlined,
                          color: Colors.white,
                          size: 100.h,
                        ),
                        Text(
                          uploadedAFile ? "Upload another file" : "SELECT FILE",
                          style:
                              TextStyle(fontSize: 50.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            )));
  }

  uploadFile() async {
    String uploadurl = "http://lab.manshore.com/file_upload.php";
    // don't use http://localhost , because emulator don't get that address
    // instead use your local IP address or use live URL
    // hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(selectedfile.path,
          filename: basename(selectedfile.path)
          //show only filename from path
          ),
      "case_id": currentCaseId
    });

    response = await dio.post(
      uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          if (double.parse(percentage) > 99)
            progress = "Uploaded Successfully";
          else
            progress = "Uploading";
          //update the progress
        });
      },
    );

    if (response.statusCode == 200) {
      print(response.toString());
      //print response from server
      setState(() {
        uploadedAFile = true;
        filePathOnServer = response.data['filePath'];
      });
      createFileRecordInDB();
    } else {
      print("Error during connection to server. code: ${response.statusCode}");
    }
  }

  selectFile() async {
    /*
    selectedfile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );*/

    //for file_pocker plugin version 2 or 2+
    /*
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    } */

    setState(() {
      progress = "Uploading..";
    });
    uploadFile(); //update the UI so that file name is shown
  }

  createFileRecordInDB() {
    LabDatabase.postQueryToDB(
        "INSERT INTO `uk_attachments` (`id`, `order_id`, `file_path`, `uploaded_at`) VALUES (null, '$currentCaseId', '$filePathOnServer', CURRENT_TIMESTAMP)");
  }
}
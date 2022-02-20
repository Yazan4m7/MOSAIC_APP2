import 'dart:async';
import 'dart:io';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic_doctors/models/uk_case.dart';
import 'package:mosaic_doctors/services/exCasesController.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/labStatementMainScreen.dart';
import 'package:path/path.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formsPageViewController = PageController();
  List? _forms;
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
  TextEditingController notes = TextEditingController();
  int? translucency = -1;
  int? surfaceTexture = -1;
  bool studyModels = false;

  GroupController miscellaneous = GroupController(isMultipleSelection: true);
  GroupController prosthetics = GroupController(isMultipleSelection: true);
  GroupController crownBridgeMetalFree =
      GroupController(isMultipleSelection: true);
  GroupController enclosedItems = GroupController(isMultipleSelection: true);
  GroupController crownBridgeMetalRestoration =
      GroupController(isMultipleSelection: true);
  GroupController implantWorkMetalFree =
      GroupController(isMultipleSelection: true);
  GroupController implantWorkMetalRestoration =
      GroupController(isMultipleSelection: true);
  GroupController implantWorkAllOn46 =
      GroupController(isMultipleSelection: true);
  GroupController selectedUnitsUR = GroupController(isMultipleSelection: true);
  GroupController selectedUnitsUL = GroupController(isMultipleSelection: true);
  GroupController selectedUnitsLL = GroupController(isMultipleSelection: true);
  GroupController selectedUnitsLR = GroupController(isMultipleSelection: true);

  DateTime selectedDate = DateTime.now();
  int currentPage = 0;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  Color expandableColor = Colors.black87;
  String currentCaseId = "null";
  late FilePickerResult? filePickerResult;
  late Response response;
  String progress = "Select file";
  Dio dio = new Dio();
  bool uploadedAFile = false;
  bool uploading = false;
  String? filePathOnServer = "null";
  static const Color TF_BG_COLOR = Colors.white;
  static int filesUploaded = 0;
  UKCase caseInfoHolder = UKCase();
  @override
  void initState() {
    /// Attach a listener which will update the state and refresh the page index
    _formsPageViewController.addListener(() {
      try {
        if (_formsPageViewController.page!.round() != currentPage) {
          setState(() {
            currentPage = _formsPageViewController.page!.round();
          });
        }
      } catch (e) {
        print("Page index not updated");
      }
    });
    filesUploaded = 0;
    super.initState();
  }

  final fontSize = 55.sp;
  final tfSize = 150.h;
  var keyboardVisibilityController = KeyboardVisibilityController();
  @override
  void dispose() {
    _formsPageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height - 350.h;

    refillLists();

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
                    currentPage < 1
                        ? () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    LabStatementMainScreen()));
                          }
                        : _previousFormStep,
                    Colors.white,
                    0.3)),
            resizeToAvoidBottomInset: false,
            body: Stack(
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
                          SingleChildScrollView(child: _forms![index]),
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
                      if (currentPage == 0)
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LabStatementMainScreen()));
                      else
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
                  backgroundColor: MaterialStateProperty.all(
                      uploading ? Colors.black12 : Colors.blueAccent),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero))),
                ),
                onPressed: uploading
                    ? null
                    : () async {
                        print("Current Page : $currentPage");
                        if (currentPage < 4)
                          _nextFormStep();
                        else
                          SharedWidgets.showMOSAICDialog(
                              "Case Created Successfully", context, "SUCCESS",
                              () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    LabStatementMainScreen()));
                          });
                        if (currentPage == 3) {
                          currentCaseId =
                              await ExternalCasesController.createCase(
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
                                  caseInfoHolder.enclosedItems,
                                  caseInfoHolder.miscellaneous,
                                  caseInfoHolder.prosthetics,
                                  caseInfoHolder.crownBridgeMetalFree,
                                  caseInfoHolder.crownBridgeMetalRestoration,
                                  caseInfoHolder.implantWorkMetalFree,
                                  caseInfoHolder.implantWorkMetalRestoration,
                                  caseInfoHolder.implantWorkAllOn46,
                                  caseInfoHolder.selectedUnitsUL,
                                  caseInfoHolder.selectedUnitsUR,
                                  caseInfoHolder.selectedUnitsLL,
                                  caseInfoHolder.selectedUnitsLR,
                                  notes.text);
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
    currentPage++;
    setState(() {});
  }

  _previousFormStep() {
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    currentPage--;
    setState(() {});
  }

  bool onWillPop() {
    if (_formsPageViewController.page!.round() ==
        _formsPageViewController.initialPage) {
      _formsPageViewController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      print("if");
    } else {
      print("else");
    }
    return false;
  }

  Widget _caseDetails1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CASE INFORMATION 1",
          style: TextStyle(fontSize: fontSize),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
              child: TextFormField(
                controller: patientName,
                style: TextStyle(
                  fontSize: 15.0,
                ),
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
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
          ),
          Container(
            height: tfSize * 1.3,
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
            height: tfSize * 1.3,
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
            child: Container(
              height: tfSize,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
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
          ),
          SizedBox(
            height: 100.h,
          )
        ]),
      ),
    );
  }

  Widget _caseDetails2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CASE INFORMATION 2",
          style: TextStyle(fontSize: fontSize),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: tfSize,
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
          ),
          Stack(
            children: <Widget>[
              Container(
                height: tfSize,
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
                height: tfSize,
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
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
              child: Container(
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
                    caseInfoHolder.enclosedItems = data;
                  },
                  isExpandableTitle: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.miscellaneous = data;
              },
              isExpandableTitle: true,
            ),
          ),
          SizedBox(
            height: 100.h,
          )
        ]),
      ),
    );
  }

  Widget _caseDetails3(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CASE INFORMATION 3",
          style: TextStyle(fontSize: fontSize),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.prosthetics = data;
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.crownBridgeMetalFree = data;
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.crownBridgeMetalRestoration = data;
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.implantWorkMetalFree = data;
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.implantWorkMetalRestoration = data;
              },
              isExpandableTitle: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 1, 20, 1),
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
                caseInfoHolder.implantWorkAllOn46 = data;
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "UNITS SELECTION",
          style: TextStyle(fontSize: fontSize),
        ),
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
                  caseInfoHolder.selectedUnitsUL = data;
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
                  caseInfoHolder.selectedUnitsUR = data;
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
                  caseInfoHolder.selectedUnitsLL = data;
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
                  caseInfoHolder.selectedUnitsLR = data;
                },
                isExpandableTitle: true,
              ),
              SizedBox(height: 100.h),
              Container(
                child: Card(
                    margin: EdgeInsets.all(5.0),
                    //color: Colors.grey.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: TextField(
                        controller: notes,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 4,
                        decoration: InputDecoration.collapsed(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 10),
                            ),
                            hintText: "Notes",
                            hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 55.sp)),
                      ),
                    )),
                decoration: new BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 0.01),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachments(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Upload Attachments (Optional)"),
          backgroundColor: Colors.blueAccent,
        ), //set appbar
        body: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 130.h),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    //show file name here
                    child: Text(
                      basename(progress),
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
                            uploadedAFile
                                ? "Upload another file"
                                : "SELECT FILE",
                            style:
                                TextStyle(fontSize: 50.sp, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            )));
  }

  void refillLists() {
    enclosedItems = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.enclosedItems);

    miscellaneous = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.miscellaneous);
    prosthetics = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.prosthetics);
    crownBridgeMetalFree = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.crownBridgeMetalFree);
    crownBridgeMetalRestoration = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.crownBridgeMetalRestoration);
    implantWorkMetalFree = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.implantWorkMetalFree);
    implantWorkMetalRestoration = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.implantWorkMetalRestoration);
    implantWorkAllOn46 = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.implantWorkAllOn46);
    selectedUnitsUR = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.selectedUnitsUR);
    selectedUnitsUL = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.selectedUnitsUL);
    selectedUnitsLL = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.selectedUnitsLL);
    selectedUnitsLR = GroupController(
        isMultipleSelection: true,
        initSelectedItem: caseInfoHolder.selectedUnitsLR);
  }

  selectFile() async {
    filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);
    List<File> files = [];
    if (filePickerResult != null) {
      files = filePickerResult!.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }

    files.forEach((File file) async {
      progress = "Uploading..";
      await uploadFile(file.path);
    });
    //update the UI so that file name is shown
  }

  uploadFile(String filePath) async {
    filesUploaded++;
    String uploadurl = "http://lab.manshore.com/file_upload.php";
    // don't use http://localhost , because emulator don't get that address
    // instead use your local IP address or use live URL
    // hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "file":
          await MultipartFile.fromFile(filePath, filename: basename(filePath)
              //show only filename from path
              ),
      "case_id": currentCaseId
    });
    uploading = true;
    response = await dio.post(
      uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          if (double.parse(percentage) > 99) {
            progress = "$filesUploaded Files Uploaded Successfully";
          } else
            progress = "Uploading ($percentage%)";
          //update the progress
        });
      },
    );

    if (response.statusCode == 200) {
      print(response.toString());
      //print response from server
      setState(() {
        uploading = false;
        uploadedAFile = true;
        filePathOnServer = response.data['filePath'];
      });
      createFileRecordInDB();
    } else {
      uploading = false;
      print("Error during connection to server. code: ${response.statusCode}");
    }
  }

  createFileRecordInDB() {
    LabDatabase.postQueryToDB(
        "INSERT INTO `uk_attachments` (`id`, `order_id`, `file_path`, `uploaded_at`) VALUES (null, '$currentCaseId', '$filePathOnServer', CURRENT_TIMESTAMP)");
  }
}

import 'package:flutter/material.dart';

/////////////////////////////////
///   TEXT STYLES
////////////////////////////////


class GlobalTheme{
  static const Color backgroundColor = Color(0xFFF2F3F8);
  static const String fontName = 'Roboto';
  static const Color grey = Color(0xFF3A5160);
  static const Color darkerText = Color(0xFF17262A);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyWhite = Color(0xFFFAFAFA);

  static TextStyle logoStyle = TextStyle(
      fontFamily: 'Pacifico',
      fontSize: 20,
      color: Colors.black54,
      letterSpacing: 2);

  static TextStyle logoWhiteStyle = TextStyle(
      fontFamily: 'Pacifico',
      fontSize: 21,
      letterSpacing: 2,
      color: Colors.white);
  static TextStyle whiteText = TextStyle(color: Colors.white, fontFamily: 'Poppins');
  static TextStyle disabledText = TextStyle(color: Colors.grey, fontFamily: 'Poppins');
  static TextStyle contrastText = TextStyle(color: Colors.white, fontFamily: 'Poppins');
  static TextStyle contrastTextBold = TextStyle(
      color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600);

  static TextStyle h3 = TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w800,
      fontFamily: 'Poppins');

  static TextStyle screenTitleTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: 'Droid',
    letterSpacing: 1,
  );

  static TextStyle textInsideButtonTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      fontFamily: 'Droid');
  static Color mainBackground = Colors.white.withOpacity(0.9);
  static TextStyle infoTextStyle = TextStyle(
      color: Colors.black.withAlpha(200),
      fontSize: 19,
      fontWeight: FontWeight.w600,
      fontFamily: 'Droid');

  static TextStyle h4 = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins');

  static TextStyle h5 = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins');

  static TextStyle h6 = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins');

  static TextStyle priceText = TextStyle(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.w800,
      fontFamily: 'Poppins');

  static TextStyle foodNameText = TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins');

  static TextStyle tabLinkStyle = TextStyle(fontWeight: FontWeight.w500);

  static TextStyle taglineText = TextStyle(color: Colors.grey, fontFamily: 'Poppins');
  static TextStyle categoryText = TextStyle(
      color: Color(0xff444444),
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins');

  static TextStyle inputFieldTextStyle =
  TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500);

  static TextStyle inputFieldHintTextStyle =
  TextStyle(fontFamily: 'Poppins', color: Color(0xff444444));

  static TextStyle inputFieldPasswordTextStyle = TextStyle(
      fontFamily: 'Poppins', fontWeight: FontWeight.w500, letterSpacing: 3);

  static  TextStyle inputFieldHintPaswordTextStyle = TextStyle(
      fontFamily: 'Poppins', color: Color(0xff444444), letterSpacing: 2);

  static TextStyle drawerTextStyle = TextStyle(
      fontFamily: 'Droid',
      color: Color(0xffe4e4e4),
      letterSpacing: 2,
      fontSize: 16);

  static ThemeData globalTheme = ThemeData(

      primaryColor: Colors.lightBlue[800],
      accentColor: Colors.cyan[600],
      scaffoldBackgroundColor: Colors.white,
// Define the default font family.
      fontFamily: 'Droid',

// Define the default TextTheme. Use this to specify the default
// text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 17.0),
        headline6: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),

      )

  );

   static const double paddingAroundCards = 20.0;

///////////////////////////////////
  /// BOX DECORATION STYLES
//////////////////////////////////

  static BoxDecoration caseDetailsViewBoxDec = BoxDecoration(
      gradient: LinearGradient(colors: [
        GlobalTheme.mainBackground,
        Colors.white
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter));

  BoxDecoration authPlateDecoration = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(0, 1))
      ],
      borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(20), bottomStart: Radius.circular(20)));

/////////////////////////////////////
  /// INPUT FIELD DECORATION STYLES
////////////////////////////////////

  OutlineInputBorder inputFieldDefaultBorderStyle = OutlineInputBorder(
      gapPadding: 0, borderRadius: BorderRadius.all(Radius.circular(6)));

}
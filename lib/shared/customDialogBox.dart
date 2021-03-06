import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text;
  final Image? img;
  final Function? onSubmit;

  const CustomDialogBox({Key? key, this.title, this.descriptions, this.text, this.img,this.onSubmit}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20,top: 45.0
              + 20, right: 20,bottom: 20
          ),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title!,style: TextStyle(fontSize: Responsiveness.dialogTitleFontSize,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text(widget.descriptions!,style: TextStyle(fontSize: Responsiveness.dialogTextFontSize),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed:  (){
                      Navigator.of(context).pop();
                      if( widget.onSubmit!= null)
                      widget.onSubmit!();
                    },
                    child: Text(widget.text!,style: TextStyle(fontSize: 18),)),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Image.asset("assets/images/Icon-Black.png")
            ),
          ),
        ),
      ],
    );
  }
}
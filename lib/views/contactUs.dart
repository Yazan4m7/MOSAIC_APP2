import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ProfileUI2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(

            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/logo_transaperant.png"
                        ),
                        fit: BoxFit.cover
                    )
                ),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  child: Container(

                    alignment: Alignment(0.0,2.5),
                    child: CircleAvatar(
                      backgroundColor:  Colors.white,
                      backgroundImage: AssetImage(
                          'assets/images/Icon-Black.png'
                      ),
                      radius: 60.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "MOSAIC DIGITAL DENTAL LAB"
                ,style: TextStyle(
                  fontSize: 22.0,
                  color:Colors.blueGrey,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Amman, Dabouq"
                ,style: TextStyle(
                  fontSize: 18.0,
                  color:Colors.black45,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(

                  "Jreisat Center 1 Khair Al Deen, Abdul Qader Al-Maani St. 46, Amman"
                  ,style: TextStyle(
                    fontSize: 15.0,
                    color:Colors.black45,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w300,

                ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Card(

                    elevation: 2.0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Designers:",style: TextStyle(
                                  fontSize: 17,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w300
                                ),),
                                SizedBox(height: 5,),
                                Text("+962788160099:",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                ),),
                              ],
                            ),
                            SizedBox(width: 50,),
                            Icon(
                              Icons.call,

                            ),
                            Icon(
                              Icons.person_add,

                            ),
                          ],
                        ))
                ),
              ),
              Container(
                width: double.infinity,
                child: Card(

                    elevation: 2.0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Designers:",style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w300
                                ),),
                                SizedBox(height: 5,),
                                Text("+962788160099:",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                ),),
                              ],
                            ),
                            SizedBox(width: 50,),
                            Icon(
                              Icons.call,

                            ),
                            Icon(
                              Icons.person_add,

                            ),
                          ],
                        ))
                ),
              ),
              Container(
                width: double.infinity,
                child: Card(

                    elevation: 2.0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Designers:",style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w300
                                ),),
                                SizedBox(height: 5,),
                                Text("+962788160099:",style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                ),),
                              ],
                            ),
                            SizedBox(width: 50,),
                            Icon(
                              Icons.call,

                            ),
                            Icon(
                              Icons.person_add,

                            ),
                          ],
                        ))
                ),
              ),
              SizedBox(
                height: 15,
              ),



            ],
          ),
        )
    );
  }
}
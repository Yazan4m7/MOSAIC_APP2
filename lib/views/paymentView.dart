import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mosaic_doctors/models/creditCard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic_doctors/services/paymentService.dart';
import 'package:mosaic_doctors/shared/MaskedTextInputFormatter.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/shared/widgets.dart';

class PaymentView extends StatefulWidget {

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  TextEditingController cardNumberTF = TextEditingController();
  TextEditingController expiryDateTF = TextEditingController();
  CreditCard  cardInfo;
  TextEditingController amountTC = TextEditingController();
  var keyboardVisibilityController = KeyboardVisibilityController();
  bool _isProcessing = false;
  List<PopupMenuEntry<String>> options = [];

  getCard() async {
    String creditCardAsString = Global.prefs.getString('card');
    print("Card from prefs as string : $creditCardAsString ");
    if(creditCardAsString!=null)
    cardInfo =   CreditCard.fromString(creditCardAsString);
    if(cardInfo!=null)
     setState(() {
       cardNumberTF.text = cardInfo.cardNumber;
       expiryDateTF.text = cardInfo.expiryDate;
     });
    }

  @override
  void initState() {

    keyboardVisibilityController.onChange.listen((bool visible) {
      if(mounted && !visible)
        setState(() {

        });

    });
   getCard();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("Payment view re-built");
    double screenHeight = MediaQuery.of(context).size.height - 22;
    //rowWidth = MediaQuery.of(context).size.width;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: _paymentViewAppBar(),

      resizeToAvoidBottomInset: false,

      body: LoadingOverlay(

        color: Colors.black87,
        progressIndicator: SharedWidgets.loadingCircle("Processing Payment"),
        isLoading: _isProcessing,
        child: SingleChildScrollView(
         // padding: EdgeInsets.only(bottom: bottom),
          reverse: true,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0,12.0,12.0,0),
              child:
     Column(
          children: <Widget>[

            Padding(
              padding:  EdgeInsets.only(top: screenHeight/19),
              child: Image.asset(
                'assets/images/MOSAIC_Group.png',
                width: Responsiveness.logoWidth.w -30,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child:Column(
                  children: <Widget>[
                    TextFormField(
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xxxx xxxx xxxx xxxx',
                          separator: ' ',
                        ),
                      ],
                      controller: cardNumberTF,
                      style: TextStyle(
                          fontSize: 20.0
                      ),

                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Credit Card Number",
                          labelStyle: TextStyle(
                              fontSize: 18.0
                          ),

                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(

                      controller: expiryDateTF,
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Credit Card Expiry Date",
                          labelStyle: TextStyle(
                              fontSize: 18.0
                          )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: amountTC,

                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Amount",
                          labelStyle: TextStyle(
                              fontSize: 18.0
                          )
                      ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    FlatButton(
                      color: Colors.black87,
                      onPressed: () async {
                        if (amountTC.text.trim().isEmpty) {SharedWidgets.showMOSAICDialog("Please enter an amount", context);return;}
                        if (cardNumberTF.text.isEmpty) {SharedWidgets.showMOSAICDialog("Please enter card number", context);return;}
                       // if (cardNumberTF.text.length != 16) {SharedWidgets.showMOSAICDialog("Invalid card number, must be 16 characters", context);return;}
                        if (expiryDateTF.text.isEmpty) {SharedWidgets.showMOSAICDialog("Please enter expiry date", context);return;}
                        setState(() {
                          _isProcessing = true;
                        });
                       await PaymentService.initializePayment(double.parse(amountTC.text.trim()),cardNumberTF.text , expiryDateTF.text,context);
                        setState(() {
                          _isProcessing = false;
                        });
                       },
                      shape: StadiumBorder(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
                        child: Text(
                          "PAY NOW",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21.0
                          ),

                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        )


            ),
          ),
        ),
      ),
    );
  }
  popupMenuAction(String optionSelected) {
    switch (optionSelected) {
      case "myCards":
      PaymentService.getMyCards();

      break;
      case "Previous Month":
      //goBackAMonth();

        break;
      case "SaveAsPDF":

        break;
      case "Refresh":

        break;
      case "fontSizeChange":

        break;
    }
  }

  Widget _paymentViewAppBar(){
    return AppBar(title: Text("NEW PAYMENT",style: TextStyle(color:Colors.black87),
    ) ,backgroundColor: Colors.transparent,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black87,),onPressed: (){Navigator.of(context).pop();},),
      centerTitle: true,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Colors.black87),

    );
  }
}
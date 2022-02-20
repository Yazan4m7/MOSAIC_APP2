import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/labStatementMainScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MepsPayment extends StatefulWidget {
  double amountToPay = 0;
  MepsPayment({required this.amountToPay});
  @override
  _MepsPaymentState createState() => _MepsPaymentState();
}

class _MepsPaymentState extends State<MepsPayment> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;
  var uri;
  @override
  void initState() {
    super.initState();
    var queryParameters = {
      'amount': widget.amountToPay.toString(),
      'customerId': getIt<SessionData>().doctor?.id,
    };
    uri = Uri.http('lab.manshore.com', '/paytn', queryParameters);
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  int loaded = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset("assets/images/ibex_white.png", height: 5),
          ),
          title: Text(
            'NEW MOSAIC PAYMENT',
            style: TextStyle(color: Colors.white, fontSize: 50.sp),
          ),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return WebView(
                    initialUrl: uri.toString(),
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      setState(() {
                        loaded = progress;
                      });
                      print("WebView is loading (progress : $progress%)");
                    },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) async {
                      if (url ==
                          "http://lab.manshore.com/onlinePayment/success")
                        SharedWidgets.showMOSAICDialog(
                            "Your payment was processed successfully",
                            context,
                            "Thank you!", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LabStatementMainScreen()));
                        });
                      if (url == "http://lab.manshore.com/onlinePayment/failed")
                        SharedWidgets.showMOSAICDialog(
                            "Your payment failed, please try again",
                            context,
                            "Sorry", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LabStatementMainScreen()));
                        });

                      setState(() {
                        isLoading = false;
                      });
                    },
                    gestureNavigationEnabled: true,
                  );
                },
              ),
              isLoading
                  ? Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              loaded.toString() + "%",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SpinKitChasingDots(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(),
            ],
          ),
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  void _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller.runJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }
}

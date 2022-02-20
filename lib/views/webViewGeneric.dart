import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewGeneric extends StatefulWidget {
  String url = "";
  String title = "";
  WebViewGeneric({required this.url, required this.title});
  @override
  _WebViewGenericState createState() => _WebViewGenericState();
}

class _WebViewGenericState extends State<WebViewGeneric> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;
  var uri;
  @override
  void initState() {
    super.initState();
    var queryParameters = {};
    uri = Uri.http('manshore.com', widget.url, {});
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
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child:
                    Image.asset("assets/images/ibex_white.png", height: 120.h),
              ),
              Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontSize: 50.sp),
              ),
            ],
          ),
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

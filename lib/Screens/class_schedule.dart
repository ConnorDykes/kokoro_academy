import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class ClassSchedule extends StatefulWidget {
  ClassSchedule({Key? key}) : super(key: key);

  @override
  State<ClassSchedule> createState() => _ClassScheduleState();
}

class _ClassScheduleState extends State<ClassSchedule> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late WebViewController _controller;
  bool loading = true;
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          drawer: CustomDrawer(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => _key.currentState!.openDrawer(),
              child: Icon(Icons.menu)),
          body: Stack(
            children: [
              //if (loading == true) CircularProgressIndicator(),
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl:
                    'https://goteamup.com/p/1165521-kokoro-training-academy/',
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    _controller = webViewController;
                  });
                },
                onPageFinished: (finished) {
                  setState(() {
                    loading = false;
                  });
                },
              ),
              Visibility(
                  visible: loading,
                  child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }
}

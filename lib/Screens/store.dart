import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class Store extends StatefulWidget {
  Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
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
                initialUrl: 'https://kokorotrainingacademy.com/shop',
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
    ;
  }
}

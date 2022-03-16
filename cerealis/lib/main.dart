import 'dart:async';

import 'package:arcore_plugin/arcore_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Components/ShareDialog.dart';

final PageController _pageController = PageController();
final ShareDialog _shareDialog = ShareDialog(_pageController);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(home: ImageRecognitionApp()));
}

class ImageRecognitionApp extends StatefulWidget {
  @override
  _ImageRecognitionAppState createState() => _ImageRecognitionAppState();
}

class _ImageRecognitionAppState extends State<ImageRecognitionApp> {
  String recongizedImage;
  ArCoreViewController arCoreViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.jpg',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('Cerealis'))
            ],

          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        bottomNavigationBar: IconButton(onPressed: () async {_pageController.jumpToPage(1);}, icon: Icon(Icons.share)),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            Center(
              child: ArCoreView(
                focusBox: Container(
                  width: screenSize.width * 0.5,
                  height: screenSize.width * 0.5,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, style: BorderStyle.solid)),
                ),
                width: screenSize.width,
                height: screenSize.height,
                onImageRecognized: _onImageRecognized,
                onArCoreViewCreated: _onArCoreViewCreated,
              ),
            ),
            _shareDialog.build(context),
          ],
        ),
      );
  }

  Future<void> _onArCoreViewCreated(ArCoreViewController controller) async {
    arCoreViewController = controller;
    await arCoreViewController.loadImgdbFromAssets(
        tempFilePath:
            '/data/user/0/com.peqas.arcorepluginexample/cache/image_database.imgdb',);
    await controller.getArCoreView();
  }

  void _onImageRecognized(String recImgName) {
    debugPrint('image recongized: $recImgName');
    _showToast('image recongized: $recImgName');

    // you can pause the image recognition via arCoreViewController.pauseImageRecognition();
    // resume it via arCoreViewController.resumeImageRecognition();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0);
  }
}

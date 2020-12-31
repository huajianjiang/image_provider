import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_provider/image_provider.dart' as img_provider;

import 'drama_category.dart';

class MyWidgetsBinding extends WidgetsFlutterBinding {
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    imageCache.maximumSizeBytes = 1024 * 1024 * 500;
    return imageCache;
  }
}

void main() {
  MyWidgetsBinding();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final imgUrl =
      'https://uploads.wifiservice.xyz/post/pictures/442a533382c1490a9b19dccc8ddb1845@180x240.jpeg';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: DramaCategory()
        //   Center(
        //       child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: <Widget>[
        //           img_provider.Image(imgUrl,
        //           width: 200,
        //           height: 100,
        //           resizeMode: img_provider.ResizeMode.centerCrop),
        //           SizedBox(height: 32,),
        //           Image.network(imgUrl,
        //             width: 200,
        //             height: 100,
        //             fit: BoxFit.scaleDown,)
        //   ],
        // )),
    ));
  }
}

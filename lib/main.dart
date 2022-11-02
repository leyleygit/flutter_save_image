import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
        home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterShareMe flutterShareMe = FlutterShareMe();

  // Future<void> shareFile() async {
  //   String? imageId = await ImageDownloader.downloadImage(imageUrl);
  //   String? path = await ImageDownloader.findPath(imageId!);

  //   await FlutterShare.shareFile(
  //     title: 'Example share',
  //     text: 'Example share text',
  //     filePath: path as String,
  //   );
  // }

  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/shareflutter-7372e.appspot.com/o/files%2Ft1.jpg?alt=media&token=8a2b4c3f-0b08-4f79-8d53-1097094895d5';
  void downloadImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(imageUrl);
      if (imageId == null) {
        return;
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Future<void> shareFile() async {
    String dir = (await getTemporaryDirectory()).path;
    var imageId = await ImageDownloader.downloadImage(
        "https://images.unsplash.com/photo-1508739773434-c26b3d09e071?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
        destination:
            AndroidDestinationType.custom(directory: dir, inPublicDir: false));

    String? path = await ImageDownloader.findPath(imageId!);

    //String path = '$dir/test.png';
    await FlutterShare.shareFile(
      title: 'Example share',
      filePath: path!,
    ).then((pa) => null);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {}),
        appBar: AppBar(),
        body: Container(
          margin: EdgeInsets.all(40),
          child: CupertinoContextMenu(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            actions: [
              CupertinoContextMenuAction(
                child: Text("Save to device"),
                onPressed: () {
                  downloadImage();
                  Navigator.of(context).pop();
                },
              ),
              CupertinoContextMenuAction(
                child: Text("Share"),
                onPressed: () {
                  shareFile();
                  //onButtonTap(Share.share_system);
                  Navigator.of(context).pop();
                },
              ),
            ],
            previewBuilder: (context, animation, child) {
              return Image.network(
                imageUrl,
                height: 200,
                width: 200,
              );
            },
          ),
        ));
  }
}

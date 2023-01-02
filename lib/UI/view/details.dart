import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wellpaper/UI/const/appColor.dart';

class Details extends StatefulWidget {
  String imagUrl;
  Details(this.imagUrl);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  setWallpaperHomeScreen(url) async {
    try {
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);

      await WallpaperManager.setWallpaperFromFile(file.path, location);
      Fluttertoast.showToast(msg: 'set successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'failed');
    }
  }

  setWallPaperlockScreen(url) async {
    try {
      int location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);

      await WallpaperManager.setWallpaperFromFile(file.path, location);
      Fluttertoast.showToast(msg: 'set successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'failed');
    }
  }
   shareImage(url) {
    Share.share(
      url,
    );
  }

  Future download(url) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      final baseStorage = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: baseStorage!.path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

 

  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        Fluttertoast.showToast(msg: 'Download Complete');
      } else {
        Fluttertoast.showToast(msg: 'failed');
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        labelsBackgroundColor: AppColor.bottonColor,
        labelsStyle: TextStyle(fontWeight: FontWeight.w600),
        speedDialChildren: [
          SpeedDialChild(
              child: Icon(
                Icons.image_outlined,
                size: 18,
              ),
              label: "Set Homescreen",
              onPressed: () => setWallpaperHomeScreen(widget.imagUrl)),
          SpeedDialChild(
              child: Icon(
                Icons.lock,
                size: 18,
              ),
              label: "Set Lockscreen",
              onPressed: () => setWallPaperlockScreen(widget.imagUrl)),
          SpeedDialChild(
            child: Icon(
              Icons.cloud_download,
              size: 18,
            ),
            label: "Download",
            onPressed: () => download('img'),
          ),
          SpeedDialChild(
              child: Icon(
                Icons.share,
                size: 18,
              ),
              label: "Share",
              onPressed: () => shareImage(widget.imagUrl)),
        ],
        child: Icon(Icons.add_circle_outline_outlined),
      ),
      body: Hero(
        tag: widget.imagUrl,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.imagUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

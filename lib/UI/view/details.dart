import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wellpaper/UI/const/appColor.dart';

class Details extends StatelessWidget {
  String imagUrl;
  Details(this.imagUrl);

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

  download(url) async {
    final taskId = await FlutterDownloader.enqueue(
      url: imagUrl,
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: 'the path of directory where you want to save downloaded files',
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  shareImage(url) {
    Share.share(
      url,
    );
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
              onPressed: () => setWallpaperHomeScreen(imagUrl)),
          SpeedDialChild(
              child: Icon(
                Icons.lock,
                size: 18,
              ),
              label: "Set Lockscreen",
              onPressed: () => setWallPaperlockScreen(imagUrl)),
          SpeedDialChild(
              child: Icon(
                Icons.cloud_download,
                size: 18,
              ),
              label: "Download",
              onPressed: () => download(imagUrl)),
          SpeedDialChild(
              child: Icon(
                Icons.share,
                size: 18,
              ),
              label: "Share",
              onPressed: () => shareImage(imagUrl)),
        ],
        child: Icon(Icons.add_circle_outline_outlined),
      ),
      body: Hero(
        tag: imagUrl,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imagUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

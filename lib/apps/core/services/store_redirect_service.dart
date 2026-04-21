import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class StoreRedirectService {
  // replace these IDs with your real app data
  static const String _androidPackageName = "com.wasel.app";
  static const String _appStoreId = "123456789"; // your app store id

  static Future<void> redirectToStore() async {
    Uri url;

    if (Platform.isAndroid) {
      // google play link
      url = Uri.parse(
        "https://play.google.com/store/apps/details?id=$_androidPackageName",
      );
    } else if (Platform.isIOS) {
      // app store link
      url = Uri.parse("https://apps.apple.com/app/id$_appStoreId");
    } else {
      // if the platform is not android or ios
      return;
    }

    // trying to open the store url
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // to open the store app
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }
}

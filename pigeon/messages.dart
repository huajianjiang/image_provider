import 'package:pigeon/pigeon.dart';

class LoadMeaasge {
  int textureId;
  String uri;
  int width = 0;
  int height = 0;
  int resizeMode = 0;
}

class TextureMessage {
  int textureId;
}

@HostApi()
abstract class ImageProviderApi {
  TextureMessage create();
  void dispose(TextureMessage msg);
  void load(LoadMeaasge msg);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = './lib/src/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FLT';
  opts.javaOut =
  'android/src/main/java/com/huajianjiang/flutter/plugins/image_provider/Messages.java';
  opts.javaOptions.package = 'com.huajianjiang.flutter.plugins.image_provider';
}
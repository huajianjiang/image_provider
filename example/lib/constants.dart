const String KEY_AUTH = '_auth';
const String KEY_USER = "_user";

class Values {
  // 禁止实例化
  Values._();

  static const double avatar_toolbar = 32;
  static const double avatar_me = 64;
  static const double avatar_profile = 48;
  static const double media_video_height_details = 238;

  static const int videoControlBackground = 0xAA000000;
}

class Test {
  static const String base_url = 'http://192.168.100.184:5000/v1/'; // 192.168.42.181, 192.168.31.246
  static const String avatar = "https://uploads.wifiservice.xyz/user/avatars/3d0700d096844817ae5200e8a4c1ffcf@128x128.jpeg";
}

class Api {
  static const String base_url = Test.base_url; // 'https://api.meijushow.com/v1/'
  static const String banner = "${Test.base_url}/banners";
  static const String drama_groups = "${Test.base_url}/dramas/groups/";
}
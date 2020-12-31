import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_provider/image_provider.dart';

void main() {
  const MethodChannel channel = MethodChannel('image_provider');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await ImageProvider.platformVersion, '42');
  // });
}

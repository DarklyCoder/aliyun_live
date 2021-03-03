import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_live/aliyun_live.dart';

void main() {
  const MethodChannel channel = MethodChannel('aliyun_live');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}

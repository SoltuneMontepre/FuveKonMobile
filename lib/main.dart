import 'package:flutter/material.dart';
import 'package:fuvekonmobile/app.dart';
import 'package:fuvekonmobile/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const FuvekonApp());
}

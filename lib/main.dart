import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reed/app.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(AppWithLocalization());
}
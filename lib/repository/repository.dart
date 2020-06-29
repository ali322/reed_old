library repository;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:reed/model/model.dart';

part 'feed.dart';
part 'item.dart';
part 'api.dart';


abstract class Repository {
  // String baseURL = 'https://play.alilab.org/rss/fever/?api';
  final http.Client httpClient = http.Client();
}

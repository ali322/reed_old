library model;

import 'package:easy_localization/easy_localization.dart';

part 'category.dart';
part 'feed.dart';
part 'entry.dart';
part 'user.dart';

String fromNow(datetime) {
  final _now = new DateTime.now();
  DateTime _datetime = datetime is String
      ? DateTime.parse(datetime)
      : DateTime.fromMillisecondsSinceEpoch(datetime * 1000);
  final _diff = _now.difference(_datetime);
  if (_diff.inMinutes < 60) {
    return '${_diff.inMinutes < 0 ? 0 : _diff.inMinutes} ${"minutes ago".tr()}';
  } else if (_diff.inHours < 10) {
    return '${_diff.inHours} ${"hours ago".tr()}';
  } else {
    _datetime = _datetime.toLocal();
    // _datetime = _datetime.add(new Duration(hours: 8));
    return '${_datetime.year}-${fixDatetime(_datetime.month)}-${fixDatetime(_datetime.day)} ${fixDatetime(_datetime.hour)}:${fixDatetime(_datetime.minute)}:${fixDatetime(_datetime.second)}';
  }
}

String fixDatetime(int val) {
  return val < 10 ? '0$val' : val.toString();
}

class PRData<T> {
  int total = 0;
  List<T> rows = [];
  PRData({total, rows});

  void appendWith(int total, List<T> newVal) {
    this.total = total;
    rows.addAll(newVal);
  }

  void replaceWith(int total, List<T> newVal) {
    this.total = total;
    rows = newVal;
  }
}

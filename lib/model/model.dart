library model;

part 'category.dart';
part 'feed.dart';
part 'entry.dart';

String fromNow(datetime) {
  final _now = new DateTime.now();
  DateTime _datetime = datetime is String
      ? DateTime.parse(datetime)
      : DateTime.fromMillisecondsSinceEpoch(datetime * 1000);
  final _diff = _now.difference(_datetime);
  if (_diff.inMinutes < 60) {
    return '${_diff.inMinutes < 0 ? 0 : _diff.inMinutes}分钟之前';
  } else if (_diff.inHours < 10) {
    return '${_diff.inHours} 小时以前';
  } else {
    _datetime = _datetime.toLocal();
    // _datetime = _datetime.add(new Duration(hours: 8));
    return '${_datetime.year}年${fixDatetime(_datetime.month)}月${fixDatetime(_datetime.day)}日 ${fixDatetime(_datetime.hour)}:${fixDatetime(_datetime.minute)}:${fixDatetime(_datetime.second)}';
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

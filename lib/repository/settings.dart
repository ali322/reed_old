part of repository;

class SettingsRepository {
  Future<Map<String, dynamic>> loadSettings() async {
    // await storage.delete(key: 'settings');
    final _ret = await storage.read(key: 'settings');
    return _ret != null ? json.decode(_ret) as Map<String, dynamic> : null;
  }

  Future<Map<String, dynamic>> saveSettings(
      {String key, dynamic value, Map<String, dynamic> values}) async {
    Map<String, dynamic> _values = {};
    _values.addAll(values);
    _values[key] = value;
    await storage.write(key: 'settings', value: jsonEncode(_values));
    return _values;
  }
}

part of repository;

class SettingsRepository {
  Future<Map<String, dynamic>> loadSettings() async {
    final _ret = await storage.read(key: 'settings');
    return _ret != null ? json.decode(_ret) as Map<String, dynamic> : null;
  }

  Future<void> saveSettings({String key, dynamic value}) {
    return storage.write(
        key: 'settings',
        value: jsonEncode(<String, dynamic>{
          key: value,
        }));
  }
}

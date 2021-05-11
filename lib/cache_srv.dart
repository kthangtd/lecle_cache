part of lecle_cache;

class _CacheService {
  static _CacheService _sInstance;
  SharedPreferences _service;

  _CacheService._();

  factory _CacheService.shared() {
    if (_sInstance == null) {
      _sInstance = _CacheService._();
    }
    return _sInstance;
  }

  static Future init() async {
    final f = await _CacheService.shared()._init();
    if (_sInstance != null && _sInstance._service.containsKey('toc')) {
      _sInstance.clear();
    }
    return f;
  }

  Future _init() async {
    _service = await SharedPreferences.getInstance();
  }

  T _get<T>(String key) {
    key = _encryptKey(key);
    final v = _service.get(key);
    if (v is T) return v;
    return null;
  }

  bool getBool(String key, {bool defValue = false}) {
    return _get<bool>(key) ?? defValue;
  }

  int getInt(String key, {int defValue = 0}) {
    return _get<int>(key) ?? defValue;
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _get<double>(key) ?? defValue;
  }

  String getString(String key, {String defValue = ""}) {
    final v = _get<String>(key);
    if (v == null) {
      return defValue;
    }
    final value = cryptoSrv.decrypt(v);
    return value ?? defValue;
  }

  List<String> getListString(String key, {List<String> defValue}) {
    List ls = _get<List>(key);
    if (ls == null) {
      return defValue ?? [];
    }
    return ls.map((e) => cryptoSrv.decrypt(e)).toList();
  }

  bool hasKey(String key) {
    key = _encryptKey(key);
    return _service.containsKey(key);
  }

  void setBool(String key, bool value) {
    key = _encryptKey(key);
    _service.setBool(key, value);
  }

  void setInt(String key, int value) {
    key = _encryptKey(key);
    _service.setInt(key, value);
  }

  void setDouble(String key, double value) {
    key = _encryptKey(key);
    _service.setDouble(key, value);
  }

  Future<bool> setString(String key, String value) {
    key = _encryptKey(key);
    final v = cryptoSrv.encrypt(value);
    return _service.setString(key, v);
  }

  Future<bool> setListString(String key, List<String> value) {
    key = _encryptKey(key);
    final v = value.map((e) => cryptoSrv.encrypt(e)).toList();
    return _service.setStringList(key, v);
  }

  Future<bool> remove(String key) {
    key = _encryptKey(key);
    return _service.remove(key);
  }

  Future<bool> clear() {
    return _service.clear();
  }

  Future<void> reload() {
    return _service.reload();
  }

  void removePrefix(String prefix) {
    _service.getKeys().forEach((key) {
      final k = cryptoSrv.decrypt(key);
      if (k.startsWith(prefix)) {
        _service.remove(key);
      }
    });
  }

  void removeExcluded(String prefix) {
    _service.getKeys().forEach((key) {
      final k = cryptoSrv.decrypt(key);
      if (!k.startsWith(prefix)) {
        _service.remove(key);
      }
    });
  }

  String _encryptKey(String key) {
    return cryptoSrv.encrypt(key);
  }
}

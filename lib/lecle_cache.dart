library lecle_cache;

import 'package:lecle_crypto/lecle_crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cache_srv.dart';

Future initCacheSrv() async {
  return _CacheService.init();
}

_CacheService get cacheSrv => _CacheService.shared();

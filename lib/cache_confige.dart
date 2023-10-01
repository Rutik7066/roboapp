 import 'package:flutter_cache_manager/flutter_cache_manager.dart';
 
  final posterCacheManager = CacheManager(Config(
    "posterCacheManager",
    stalePeriod: const Duration(days: 30),
  ));

  
final eventCacheManager = CacheManager(Config(
  "eventCacheManager",
  stalePeriod: const Duration(days: 1),
));

final eventSelectionCacheManager = CacheManager(Config(
  "eventCacheManager",
  stalePeriod: const Duration(days: 1),
));

final otherCacheManager = CacheManager(Config(
  "otherCacheManager",
  stalePeriod: const Duration(days: 30),
));


final otherSelectionCacheManager = CacheManager(Config(
  "otherCacheManager",
  stalePeriod: const Duration(days: 30),
));

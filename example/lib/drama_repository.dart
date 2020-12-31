import 'package:chopper/chopper.dart';

import 'data_source.dart';
import 'drama.dart';
import 'network.dart';

class DramaRepository implements DramaDataSource {
  static final DramaRepository _instance = DramaRepository._internal();

  Map<String, Dramas> _cachedDramas = {};

  factory DramaRepository() {
    return _instance;
  }

  DramaRepository._internal();

  List<Drama> getCachedDramas(String category) {
    List<Drama> data = [];
    Dramas dramas = _cachedDramas[category];
    if (dramas != null) {
      data.addAll(dramas.dramas);
    }
    return data;
  }

  @override
  Future<Dramas> getDramas(int page, String category,
      {int perPage = 12, LoadingState state = LoadingState.def}) async {
    if (state == LoadingState.def &&
        _cachedDramas.containsKey(category) &&
        _cachedDramas[category].dramas.isNotEmpty) {
      return _cachedDramas[category];
    }
    return await apiService.getDramas({
      'page': page,
      'category': category,
      'per_page': perPage
    }).then((Response<Dramas> resp) {
      if (!_cachedDramas.containsKey(category) || state == LoadingState.refresh) {
        _cachedDramas[category] = resp.body;
      } else {
        _cachedDramas[category].meta = resp.body.meta;
        _cachedDramas[category].dramas.addAll(resp.body.dramas);
      }
      return resp.body;
    });
  }

  @override
  Future<Drama> getDramaDetails(String dramaId) {
    return apiService.getDramaDetails(dramaId).then(takeBody);
  }

}

final dramaRepo = DramaRepository();
import 'drama.dart';
import 'network.dart';

abstract class DramaDataSource {
  Future<Dramas> getDramas(int page, String category,
      {int perPage = 12, LoadingState state = LoadingState.def});
  Future<Drama> getDramaDetails(String dramaId);
}

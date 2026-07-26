import 'package:self_study/features/lhc_control/domain/models/lhc_state.dart';
import 'package:self_study/features/lhc_control/domain/repositories/lhc_repository.dart';

import '../data_sources/lhc_remote_data_source.dart';

class LHCRepositoryImpl implements LHCRepository {
  final LHCRemoteDataSource _remoteDataSource;

  LHCRepositoryImpl(this._remoteDataSource);

  @override
  Future<LHCState> fetchInitialControlState() async {
    return await _remoteDataSource.getLatestControlRoomData();
  }
}

import '../models/lhc_state.dart';

abstract class LHCRepository {
  Future<LHCState> fetchInitialControlState();
}

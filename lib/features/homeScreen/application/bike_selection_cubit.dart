import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/bike_mode.dart';
import '../../../../core/services/preferences_service.dart';
import 'bike_selection_state.dart';

class BikeSelectionCubit extends Cubit<BikeSelectionState> {
  BikeSelectionCubit(this._prefs) : super(const BikeSelectionInitial()) {
    final saved = _prefs.getBikeMode();
    if (saved != null) emit(BikeSelectionUpdated(saved));
  }

  final PreferencesService _prefs;

  void selectMode(BikeMode mode) {
    _prefs.saveBikeMode(mode);
    emit(BikeSelectionUpdated(mode));
  }

  void clearSelection() {
    emit(const BikeSelectionInitial());
  }
}

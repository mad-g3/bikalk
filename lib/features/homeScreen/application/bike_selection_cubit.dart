import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/value_objects/bike_mode.dart';
import 'bike_selection_state.dart';

class BikeSelectionCubit extends Cubit<BikeSelectionState> {
  BikeSelectionCubit() : super(const BikeSelectionInitial());

  void selectMode(BikeMode mode) {
    emit(BikeSelectionUpdated(mode));
  }

  void clearSelection() {
    emit(const BikeSelectionInitial());
  }
}

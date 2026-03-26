import 'package:equatable/equatable.dart';
import '../../../../core/domain/bike_mode.dart';

abstract class BikeSelectionState extends Equatable {
  const BikeSelectionState();

  @override
  List<Object?> get props => [];
}

class BikeSelectionInitial extends BikeSelectionState {
  const BikeSelectionInitial();
}

class BikeSelectionUpdated extends BikeSelectionState {
  final BikeMode selectedMode;

  const BikeSelectionUpdated(this.selectedMode);

  @override
  List<Object?> get props => [selectedMode];
}

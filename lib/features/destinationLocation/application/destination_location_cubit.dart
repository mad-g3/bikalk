import 'package:flutter_bloc/flutter_bloc.dart';
import 'destination_location_state.dart';

class DestinationLocationCubit extends Cubit<DestinationLocationState> {
  DestinationLocationCubit() : super(const DestinationLocationInitial());

  /// Stores the user's selected destination so downstream screens can read it.
  void selectDestination(String destination) {
    emit(DestinationLocationSelected(destination));
  }

  /// Resets back to the initial state (e.g. if the user goes back).
  void clearDestination() {
    emit(const DestinationLocationInitial());
  }
}

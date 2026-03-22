import 'package:equatable/equatable.dart';

abstract class DestinationLocationState extends Equatable {
  const DestinationLocationState();

  @override
  List<Object?> get props => [];
}

/// Nothing has been selected yet
class DestinationLocationInitial extends DestinationLocationState {
  const DestinationLocationInitial();
}

/// The user has chosen a destination
class DestinationLocationSelected extends DestinationLocationState {
  const DestinationLocationSelected(this.destination);

  final String destination;

  @override
  List<Object?> get props => [destination];
}

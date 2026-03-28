import '../../auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.user);

  final UserEntity user; // keep showing current data while saving
  @override
  List<Object?> get props => [user];
}

class ProfileSuccess extends ProfileState {
  const ProfileSuccess(this.user, this.message);

  final UserEntity user;
  final String message;

  @override
  List<Object?> get props => [user, message];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}

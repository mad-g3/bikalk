import '../../auth/domain/entities/user_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded(this.user);
  final UserEntity user;
}

class ProfileUpdating extends ProfileState {
  ProfileUpdating(this.user);
  final UserEntity user; // keep showing current data while saving
}

class ProfileSuccess extends ProfileState {
  ProfileSuccess(this.user, this.message);
  final UserEntity user;
  final String message;
}

class ProfileError extends ProfileState {
  ProfileError(this.message);
  final String message;
}

class ProfileDeleted extends ProfileState {}

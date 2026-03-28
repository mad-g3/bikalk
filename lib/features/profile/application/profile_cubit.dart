import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/data/models/user_model.dart';
import '../../auth/data/sources/firestore_user_source.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required FirestoreUserSource userSource,
    required FirebaseAuth firebaseAuth,
  })  : _userSource = userSource,
        _firebaseAuth = firebaseAuth,
        super(ProfileInitial());

  final FirestoreUserSource _userSource;
  final FirebaseAuth _firebaseAuth;

  String? get _uid => _firebaseAuth.currentUser?.uid;

  // Read
  Future<void> loadProfile() async {
    final uid = _uid;
    if (uid == null) {
      emit(ProfileError('Not signed in'));
      return;
    }
    emit(ProfileLoading());
    try {
      final model = await _userSource.getUser(uid);
      if (model == null) {
        emit(ProfileError('User not found'));
        return;
      }
      emit(ProfileLoaded(model.toEntity()));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Update
  Future<void> updateName(String name) async {
    final currentState = state;
    final currentUser = currentState is ProfileLoaded
        ? currentState.user
        : currentState is ProfileSuccess
            ? currentState.user
            : null;
    if (currentUser == null) return;

    emit(ProfileUpdating(currentUser));
    try {
      await _userSource.updateName(currentUser.userId, name);
      final updated = UserModel.fromEntity(currentUser).toMap();
      updated['name'] = name;
      final updatedEntity = UserModel.fromMap(updated).toEntity();
      emit(ProfileSuccess(updatedEntity, 'Name updated'));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Delete
  Future<void> deleteAccount() async {
    final uid = _uid;
    if (uid == null) {
      emit(ProfileError('Not signed in'));
      return;
    }
    emit(ProfileLoading());
    try {
      await _userSource.deleteUser(uid);
      await _firebaseAuth.currentUser?.delete();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

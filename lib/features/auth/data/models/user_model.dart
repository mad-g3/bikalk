import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isEmailVerified,
  });

  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isEmailVerified;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      isEmailVerified: data['isEmailVerified'] as bool? ?? false,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      isEmailVerified: map['isEmailVerified'] as bool? ?? false,
    );
  }

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      userId: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      phoneNumber: firebaseUser.phoneNumber ?? '',
      isEmailVerified: firebaseUser.emailVerified,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      isEmailVerified: entity.isEmailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      isEmailVerified: isEmailVerified,
    );
  }
}

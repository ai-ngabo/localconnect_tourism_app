import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  const UserProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  UserProfileEntity copyWith({String? name, String? email, String? photoUrl}) {
    return UserProfileEntity(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, photoUrl];
}

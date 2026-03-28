import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String photoUrl;

  const UserProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.bio = '',
    this.photoUrl = '',
  });

  UserProfileEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? photoUrl,
  }) {
    return UserProfileEntity(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, phone, bio, photoUrl];
}

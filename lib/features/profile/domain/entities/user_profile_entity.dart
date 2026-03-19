import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String name;
  final String email;

  const UserProfileEntity({
    required this.uid,
    required this.name,
    required this.email,
  });

  UserProfileEntity copyWith({String? name, String? email}) {
    return UserProfileEntity(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [uid, name, email];
}

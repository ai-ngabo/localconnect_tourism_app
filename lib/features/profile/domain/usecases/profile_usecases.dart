import 'dart:io';

import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserProfileEntity?> call() => repository.getProfile();
}

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({
    required String name,
    String? phone,
    String? bio,
  }) =>
      repository.updateProfile(name: name, phone: phone, bio: bio);
}

class UploadProfilePhotoUseCase {
  final ProfileRepository repository;

  UploadProfilePhotoUseCase(this.repository);

  Future<String> call(File imageFile) =>
      repository.uploadProfilePhoto(imageFile);
}

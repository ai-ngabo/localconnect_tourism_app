import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/profile_usecases.dart';

// ── States ─────────────────────────────────────────────────────────────────
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
  final UserProfileEntity profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdating extends ProfileState {
  final UserProfileEntity profile;

  const ProfileUpdating(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfileEntity profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfilePhotoUseCase uploadProfilePhotoUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadProfilePhotoUseCase,
  }) : super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final profile = await getProfileUseCase();
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(const ProfileError('Could not load profile.'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    String? bio,
  }) async {
    final current = state;
    final currentProfile = current is ProfileLoaded
        ? current.profile
        : current is ProfileUpdateSuccess
            ? current.profile
            : null;
    if (currentProfile == null) return;

    emit(ProfileUpdating(currentProfile));
    try {
      await updateProfileUseCase(name: name, phone: phone, bio: bio);
      final updated = currentProfile.copyWith(
        name: name,
        phone: phone,
        bio: bio,
      );
      emit(ProfileUpdateSuccess(updated));
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> uploadPhoto(File imageFile) async {
    final current = state;
    final currentProfile = current is ProfileLoaded ? current.profile : null;
    if (currentProfile == null) return;

    emit(ProfileUpdating(currentProfile));
    try {
      final photoUrl = await uploadProfilePhotoUseCase(imageFile);
      final updated = currentProfile.copyWith(photoUrl: photoUrl);
      emit(ProfileUpdateSuccess(updated));
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError('Could not upload photo. Please try again.'));
      emit(ProfileLoaded(currentProfile));
    }
  }
}

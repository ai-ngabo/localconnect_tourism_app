import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  }) : super(const AuthInitial()) {
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await signInUseCase(
        SignInParams(email: event.email, password: event.password),
      );
      emit(AuthAuthenticated(user));
    } on fb_auth.FirebaseAuthException catch (e) {
      final message = _mapFirebaseAuthError(e);
      emit(AuthError(message));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('email_not_verified:')) {
        final email = msg.split('email_not_verified:').last;
        emit(AuthEmailNotVerified(email));
      } else {
        emit(const AuthError('Something went wrong. Please try again.'));
      }
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await signUpUseCase(
        SignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
      emit(AuthSignUpSuccess(event.email));
    } on fb_auth.FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email.';
          break;
        case 'weak-password':
          message = 'Password must be at least 6 characters.';
          break;
        default:
          message = e.message ?? 'Something went wrong. Please try again.';
      }
      emit(AuthError(message));
    } catch (_) {
      emit(const AuthError('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
    await signOutUseCase(NoParams());
    emit(const AuthUnauthenticated());
  }

  String _mapFirebaseAuthError(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}

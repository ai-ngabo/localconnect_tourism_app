import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignUpUseCase implements UseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<void> call(SignUpParams params) {
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

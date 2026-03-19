import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signIn({required String email, required String password}) {
    return remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signUp({required String name, required String email, required String password}) {
    return remoteDataSource.signUp(name: name, email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }
}

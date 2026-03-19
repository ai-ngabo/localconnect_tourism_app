import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:get_it/get_it.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Tourism
import '../../features/tourism/data/repositories/tour_repository_impl.dart';
import '../../features/tourism/domain/repositories/tour_repository.dart';
import '../../features/tourism/domain/usecases/get_tours_usecase.dart';
import '../../features/tourism/presentation/cubit/tourism_cubit.dart';

// Booking
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/add_booking_usecase.dart';
import '../../features/booking/domain/usecases/get_bookings_usecase.dart';
import '../../features/booking/presentation/cubit/booking_form_cubit.dart';
import '../../features/booking/presentation/cubit/bookings_list_cubit.dart';

// Favorites
import '../../features/settings/data/repositories/favorites_repository_impl.dart';
import '../../features/settings/domain/repositories/favorites_repository.dart';
import '../../features/settings/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/settings/presentation/cubit/favorites_cubit.dart';

// Profile
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Firebase ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<fb_auth.FirebaseAuth>(
      () => fb_auth.FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ── Auth ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );

  // ── Tourism ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<TourRepository>(() => TourRepositoryImpl());
  sl.registerLazySingleton(() => GetToursUseCase(sl()));
  sl.registerLazySingleton(() => GetGuidesUseCase(sl()));
  sl.registerFactory(
    () => TourismCubit(
      getToursUseCase: sl(),
      getGuidesUseCase: sl(),
    ),
  );

  // ── Booking ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(firestore: sl()),
  );
  sl.registerLazySingleton(() => AddBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePastBookingsUseCase(sl()));
  sl.registerFactory(
    () => BookingFormCubit(addBookingUseCase: sl()),
  );
  sl.registerFactory(
    () => BookingsListCubit(
      getBookingsUseCase: sl(),
      updatePastBookingsUseCase: sl(),
    ),
  );

  // ── Favorites ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton(() => WatchFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerFactory(
    () => FavoritesCubit(
      watchFavoritesUseCase: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );

  // ── Profile ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );
}

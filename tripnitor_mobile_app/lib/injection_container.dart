import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripnitor_mobile_app/core/network/network_info.dart';
import 'package:tripnitor_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_local_token.dart';
import 'features/auth/domain/usecases/get_local_user.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
    //AUTH RELATED DEPENDENCIES
    //BLOC
    sl.registerFactory(() => AuthBloc(
        loginUser: sl(),
        registerUser: sl(),
        logoutUser: sl(), 
        getLocalUser: sl(),
        getLocalToken: sl(),
    ));

    //USECASES
    sl.registerLazySingleton(() => LoginUser(sl()));
    sl.registerLazySingleton(() => RegisterUser(sl()));
    sl.registerLazySingleton(() => LogoutUser(sl()));
    sl.registerLazySingleton(() => GetLocalUser(sl()));
    sl.registerLazySingleton(() => GetLocalToken(sl()));

    //REPOSITORIES
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
    ));

    //DATASOURCES
    sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl())
    );

    sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl())
    );

    //CORE DEPENDENCIES ONLY
    sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl())
    );

    //EXTERNAL DEPENDENCIES ONLY
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => dio.Dio());
    sl.registerLazySingleton(() => InternetConnectionChecker());
    
}
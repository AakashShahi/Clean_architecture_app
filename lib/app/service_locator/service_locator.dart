import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:student_management/core/network/api_service.dart';
import 'package:student_management/core/network/hive_service.dart';
import 'package:student_management/features/auth/data/data_source/local_datasource/student_local_datasource.dart';
import 'package:student_management/features/auth/data/data_source/remote_datasource/student_remote_datasource.dart';
import 'package:student_management/features/auth/data/repository/local_repository/student_local_repository.dart';
import 'package:student_management/features/auth/data/repository/remote_repository/student_remote_repository.dart';
import 'package:student_management/features/auth/domain/use_case/student_get_current__usecase.dart';
import 'package:student_management/features/auth/domain/use_case/student_image_upload_usecase.dart';
import 'package:student_management/features/auth/domain/use_case/student_login_usecase.dart';
import 'package:student_management/features/auth/domain/use_case/student_register_usecase.dart';
import 'package:student_management/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:student_management/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:student_management/features/batch/data/data_source/local_datasource/batch_local_data_source.dart';
import 'package:student_management/features/batch/data/data_source/remote_datasource/batch_remote_datasource.dart';
import 'package:student_management/features/batch/data/repository/local_repository/batch_local_repositry.dart';
import 'package:student_management/features/batch/data/repository/remote_repository/batch_remote_repository.dart';
import 'package:student_management/features/batch/domain/use_case/create_batch_usecase.dart';
import 'package:student_management/features/batch/domain/use_case/delete_batch_usecase.dart';
import 'package:student_management/features/batch/domain/use_case/getall_batch_usecase.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_view_model.dart';
import 'package:student_management/features/course/data/data_source/local_datasource/course_local_datasource.dart';
import 'package:student_management/features/course/data/data_source/remote_datasource/course_remote_datasource.dart';
import 'package:student_management/features/course/data/repository/local_repository/course_local_repository.dart';
import 'package:student_management/features/course/data/repository/remote_repository/course_remote_repository.dart';
import 'package:student_management/features/course/domain/use_case/create_course_usecas.dart';
import 'package:student_management/features/course/domain/use_case/delete_course_usecase.dart';
import 'package:student_management/features/course/domain/use_case/get_course_usecase.dart';
import 'package:student_management/features/course/presentation/view_model/course_view_model.dart';
import 'package:student_management/features/home/presentation/view_model/home_view_model.dart';
import 'package:student_management/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initCourseModule();
  await _initBatchModule();
  await _initHomeModule();
  await _initAuthModule();
  await _initSplashModule();
  await initApiModule();
}

Future _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future _initCourseModule() async {
  serviceLocator.registerFactory<CourseLocalDataSource>(
    () => CourseLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<CourseRemoteDataSource>(
    () => CourseRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<CourseLocalRepository>(
    () => CourseLocalRepository(
      courseLocalDataSource: serviceLocator<CourseLocalDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<CourseRemoteRepository>(
    () => CourseRemoteRepository(
      courseRemoteDataSource: serviceLocator<CourseRemoteDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<CreateCourseUseCase>(
    () => CreateCourseUseCase(
      courseRepository: serviceLocator<CourseRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetallCourseUsecase>(
    () => GetallCourseUsecase(
      courseRepository: serviceLocator<CourseRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<DeleteCourseUsecase>(
    () => DeleteCourseUsecase(
      repository: serviceLocator<CourseRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory<CourseViewModel>(
    () => CourseViewModel(
      getAllCourseUsecase: serviceLocator<GetallCourseUsecase>(),
      createCourseUsecase: serviceLocator<CreateCourseUseCase>(),
      deleteCourseUsecase: serviceLocator<DeleteCourseUsecase>(),
    ),
  );
}

Future _initBatchModule() async {
  serviceLocator.registerFactory<BatchLocalDataSource>(
    () => BatchLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory<BatchRemoteDatasource>(
    () => BatchRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<BatchLocalRepositry>(
    () => BatchLocalRepositry(
      batchLocalDataSoure: serviceLocator<BatchLocalDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<BatchRemoteRepository>(
    () => BatchRemoteRepository(
      batchRemoteDatasource: serviceLocator<BatchRemoteDatasource>(),
    ),
  );

  serviceLocator.registerLazySingleton<CreateBatchUseCase>(
    () => CreateBatchUseCase(
      batchRepository: serviceLocator<BatchRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<GetallBatchUsecase>(
    () => GetallBatchUsecase(
      batchRepository: serviceLocator<BatchRemoteRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<DeleteBatchUsecase>(
    () =>
        DeleteBatchUsecase(repository: serviceLocator<BatchRemoteRepository>()),
  );

  serviceLocator.registerFactory(
    () => BatchViewModel(
      createBatchUseCase: serviceLocator<CreateBatchUseCase>(),
      getAllBatchUseCase: serviceLocator<GetallBatchUsecase>(),
      deleteBatchUsecase: serviceLocator<DeleteBatchUsecase>(),
    ),
  );
}

Future _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

Future _initAuthModule() async {
  serviceLocator.registerFactory(
    () => StudentLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory(
    () => StudentRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => StudentLocalRepository(
      studentLocalDatasource: serviceLocator<StudentLocalDatasource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => StudentRemoteRepository(
      studentRemoteDataource: serviceLocator<StudentRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => StudentLoginUsecase(
      studentRepository: serviceLocator<StudentRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => StudentRegisterUsecase(
      studentRepository: serviceLocator<StudentRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UploadImageUsecase(
      studentRepository: serviceLocator<StudentRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => StudentGetCurrentUsecase(
      studentRepository: serviceLocator<StudentRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      serviceLocator<BatchViewModel>(),
      serviceLocator<CourseViewModel>(),
      serviceLocator<StudentRegisterUsecase>(),
      serviceLocator<UploadImageUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<StudentLoginUsecase>()),
  );
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> initApiModule() async {
  // Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

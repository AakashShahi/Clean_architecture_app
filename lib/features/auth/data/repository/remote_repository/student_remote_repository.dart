import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/auth/data/data_source/remote_datasource/student_remote_datasource.dart';
import 'package:student_management/features/auth/domain/entity/student_entity.dart';
import 'package:student_management/features/auth/domain/repository/student_repository.dart';

class StudentRemoteRepository implements IStudentRepository {
  final StudentRemoteDataSource _studentRemoteDatasource;

  StudentRemoteRepository({
    required StudentRemoteDataSource studentRemoteDataource,
  }) : _studentRemoteDatasource = studentRemoteDataource;

  @override
  Future<Either<Failure, StudentEntity>> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginStudent(
    String username,
    String password,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> registerStudent(StudentEntity student) async {
    try {
      await _studentRemoteDatasource.registerStudent(student);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final img = await _studentRemoteDatasource.uploadProfilePicture(file);
      return Right(img);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}

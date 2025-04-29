import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/tattoo.dart';
import '../../domain/repositories/tattoo_repository.dart';
import '../../domain/usecases/generate_tattoo.dart';
import '../datasources/tattoo_remote_data_source.dart';

class TattooRepositoryImpl implements TattooRepository {
  final TattooRemoteDataSource remoteDataSource;

  TattooRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Tattoo>> generateTattoo(GenerateTattooParams params) async {
    try {
      final tattoo = await remoteDataSource.generateTattoo(params);
      return Right(tattoo);
    } catch (e) {
      return Left(GenerationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTattoo(String imageUrl) async {
    try {
      await remoteDataSource.saveTattoo(imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> shareTattoo(String imageUrl) async {
    try {
      await remoteDataSource.shareTattoo(imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getRandomPrompt() async {
    try {
      final prompt = await remoteDataSource.getRandomPrompt();
      return Right(prompt);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
